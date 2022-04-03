# Diagnostic diagnostics-runners Runner
This repo represents a container and utility scripts for diagnostics-runnering and troubleshooting.


# How to run it:
Use our handy incantations:

**1. Build your docker image**
```
cp .env.example .env
docker build -f Dockerfile . --tag diagnostics-runner
```
## Locally reporting to New Relic NRDB

**2. Make/copy your NRDB insert key**

Go to [API Keys](https://one.newrelic.com/launcher/api-keys-ui.launcher?pane=eyJuZXJkbGV0SWQiOiJhcGkta2V5cy11aS5ob21lIn0=), then click on "New Relic insert keys".

Put this file into your `.env` file.

**3. Run (after the building step)**

```
docker run --rm --env-file=.env -e OUTER_HOSTNAME=`hostname` diagnostics-runner
```

## How to disable scripts

If you want to disable a particular script:

* For the ones you wish to disable, set `-e DISABLE_<SCRIPTNAME>=true`:
```
# In this example, the PINGER and DIGGER script will be disabled, but the CURLER will not.

docker run -e EVENTS_INSERT_API_KEY=<MALARKEY> -e DISABLE_PINGER=true -e DISABLE_DIGGER=true -it --rm diagnostics-runner
```

# Running locally on a raspberry pi

```
DOCKER_HOST="ssh://pi@raspberrypi.local" docker build -f Dockerfile . --tag diagnostics-runner
DOCKER_HOST="ssh://pi@raspberrypi.local" docker run --rm -it  diagnostics-runner
```

# New Relic dashboard

This is a pre-formatted JSON that you can edit and import into New Relic if you choose to do so. You'll need to change the account id, and the filters will need to be edited to add the "Filter to the current dashboard" bit back in.

```
{
  "name": "Utility Container Investigation (Diagnostics Runner)",
  "description": null,
  "permissions": "PUBLIC_READ_WRITE",
  "pages": [
    {
      "name": "Utility Container Investigation",
      "description": null,
      "widgets": [
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 1,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "\n# Values are in ms. \nSub-millisecond times are possible\n\n---\n\nYou can filter using the bars right -- --- -- &gt;&gt;&gt;\n"
          }
        },
        {
          "title": "Filter by ping target (max ping time_ms)",
          "layout": {
            "column": 5,
            "row": 1,
            "width": 3,
            "height": 3
          },
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsCurl select max(dns_resolution) FACET local_ip, remote_ip"
              }
            ]
          }
        },
        {
          "title": "",
          "layout": {
            "column": 8,
            "row": 1,
            "width": 2,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "![1](https://web.archive.org/web/20090725045434im_/http://au.geocities.com/pammyau2001/dinosaur.gif)\n\n# Don't Panic"
          }
        },
        {
          "title": "Filter by DNS server (max ping time_ms)",
          "layout": {
            "column": 10,
            "row": 1,
            "width": 3,
            "height": 3
          },
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing select max(time_ms) facet dns_server_pinged LIMIT 50"
              }
            ]
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 4,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "Ping Test\n---\n* How fast are pings to DNS servers?\n* Does it matter what Environment is pinging?\n* Does it matter what datacenter?"
          }
        },
        {
          "title": "95% ping response times by  DNS server",
          "layout": {
            "column": 5,
            "row": 4,
            "width": 8,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "facet": {
              "showOtherSeries": false
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing SELECT percentile(time_ms, 95) facet dns_server_pinged TIMESERIES MAX"
              },
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing select max(packet_loss_percent) as 'Any Packet Loss'  facet dns_server_pinged timeseries MAX"
              }
            ],
            "yAxisLeft": {
              "max": 2,
              "min": 0.01,
              "zero": false
            }
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 7,
            "width": 12,
            "height": 1
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "----"
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 8,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "Connecting to a service\n---\n* How quickly are we connecting to it\n* How fast are each of the connection events?\n* Is any part of connect taking particularly long at a particular location?"
          }
        },
        {
          "title": "Max aggregate time for connection events",
          "layout": {
            "column": 5,
            "row": 8,
            "width": 8,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "From DiagnosticsCurl select percentile(dns_resolution, 95) as 'DNS Resolution', percentile(tcp_established-dns_resolution, 95) as 'TCP Established', percentile(ssl_handshake_done-tcp_established, 95) as 'SSL Handshake', percentile(time_to_filetransfer_begin-ssl_handshake_done, 95) as 'Time to Transfer' timeseries MAX"
              }
            ],
            "yAxisLeft": {
              "max": 0.25,
              "min": 0.01,
              "zero": false
            }
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 11,
            "width": 12,
            "height": 1
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "--------"
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 12,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "Using DNS to find the server\n---\n* How long does it take to ask for the service by domain name?\n* Does it matter what DNS server we ask?\n* Does it matter where we are asking from?"
          }
        },
        {
          "title": "Number of runners",
          "layout": {
            "column": 5,
            "row": 12,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.billboard"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDig SELECT uniqueCount(primary_ip) FACET hostname"
              }
            ],
            "thresholds": []
          }
        },
        {
          "title": "DNS lookup from dig (ms)",
          "layout": {
            "column": 9,
            "row": 12,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "facet": {
              "showOtherSeries": false
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "from DiagnosticsDig select percentile(query_time_ms, 95) facet dns_server_ip, primary_ip timeseries max"
              }
            ],
            "yAxisLeft": {
              "max": 30,
              "min": 0.01,
              "zero": false
            }
          }
        }
      ]
    },
    {
      "name": "Pingers",
      "description": null,
      "widgets": [
        {
          "title": "Filter by hostname",
          "layout": {
            "column": 1,
            "row": 1,
            "width": 3,
            "height": 3
          },
          "visualization": {
            "id": "viz.bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing SELECT count(*) AS 'Pings' FACET hostname "
              }
            ]
          }
        },
        {
          "title": "Filter by dns server",
          "layout": {
            "column": 4,
            "row": 1,
            "width": 3,
            "height": 3
          },
          "visualization": {
            "id": "viz.bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing SELECT max(time_ms) FACET dns_server_pinged"
              }
            ]
          }
        },
        {
          "title": "Filter by primary ip",
          "layout": {
            "column": 7,
            "row": 1,
            "width": 3,
            "height": 3
          },
          "visualization": {
            "id": "viz.bar"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing SELECT max(time_ms) FACET primary_ip"
              }
            ]
          }
        },
        {
          "title": "Ping times (ms)",
          "layout": {
            "column": 1,
            "row": 4,
            "width": 6,
            "height": 4
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing SELECT percentile(time_ms, 99.999) facet hostname, dns_server_pinged TIMESERIES MAX LIMIT 40"
              }
            ],
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "Packet loss (%)",
          "layout": {
            "column": 7,
            "row": 4,
            "width": 6,
            "height": 4
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.line"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing select max(packet_loss_percent) as 'Any Packet Loss' facet primary_ip, dns_server_pinged timeseries MAX LIMIT 40"
              }
            ],
            "yAxisLeft": {
              "zero": true
            }
          }
        }
      ]
    }
  ]
}
```

### Credits

Thanks to the authors of these fabulous posts:
- How to get your wan ip via bash: https://unix.stackexchange.com/a/81699
-
