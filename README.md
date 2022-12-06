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

## Pi clone setup

Adding myself to the sudoers file
```
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password"
```

Copying in my ssh key
```
ssh-copy-id -i ~/.ssh/id_ed25519 vosechu@lepotato-at-router
ssh-copy-id -i ~/.ssh/id_ed25519 vosechu@lepotato-at-office
```

Installing docker
```
curl -fsSL https://get.docker.com -o get-docker.sh
DRY_RUN=1 sudo sh ./get-docker.sh
sudo sh ./get-docker.sh

# Boot docker automatically
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Install rootless mode manually
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

Downloading and building the diagnostics image
```
git clone https://github.com/vosechu/local-diagnostics-runner.git
cd local-diagnostics-runner

# Add in your api key (instructions above)
cp .env.example .env
vi .env

# Build the image
docker build -f Dockerfile . --tag diagnostics-runner

# Run the image manually to see how it goes
docker run --rm --env-file=.env -e OUTER_HOSTNAME=`hostname` diagnostics-runner
```

Starting the diagnostics image automatically on boot
```
docker run -d --restart unless-stopped --env-file=.env -e OUTER_HOSTNAME=`hostname` diagnostics-runner
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
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTQ"
          ],
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
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTQ"
          ],
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
          "title": "95th% ping response times by  DNS server (ms)",
          "layout": {
            "column": 5,
            "row": 4,
            "width": 4,
            "height": 3
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
                "query": "FROM DiagnosticsDnsPing SELECT percentile(time_ms, 95) facet dns_server_pinged TIMESERIES MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "max": 15,
              "min": 0.01,
              "zero": false
            }
          }
        },
        {
          "title": "95th% ping response times by hostname (ms)",
          "layout": {
            "column": 9,
            "row": 4,
            "width": 4,
            "height": 3
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
                "query": "FROM DiagnosticsDnsPing SELECT percentile(time_ms, 95) facet hostname, dns_server_pinged TIMESERIES MAX"
              },
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDnsPing select max(packet_loss_percent) as 'Packet Loss %' timeseries MAX"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "max": 15,
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
            "text": "Connecting to our service\n---\n* How quickly are we connecting to our service?\n* How fast are each of the connection events?\n* Is any part of connect taking particularly long at a particular location?"
          }
        },
        {
          "title": "Max aggregate time for connection events (ms)",
          "layout": {
            "column": 5,
            "row": 8,
            "width": 4,
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
                "query": "From DiagnosticsCurl select percentile(dns_resolution, 95) * 1000 as 'DNS Resolution', percentile(tcp_established-dns_resolution, 95) * 1000 as 'TCP Established', percentile(ssl_handshake_done-tcp_established, 95) * 1000 as 'SSL Handshake', percentile(time_to_filetransfer_begin-ssl_handshake_done, 95) * 1000 as 'Time to Transfer' timeseries MAX"
              }
            ],
            "yAxisLeft": {
              "max": 1000,
              "min": 0.01,
              "zero": false
            }
          }
        },
        {
          "title": "Max aggregate time for connection events (ms)",
          "layout": {
            "column": 9,
            "row": 8,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.area"
          },
          "rawConfiguration": {
            "dataFormatters": [],
            "legend": {
              "enabled": true
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "From DiagnosticsCurl select percentile(dns_resolution, 95) * 1000 as 'DNS Resolution', percentile(tcp_established-dns_resolution, 95) * 1000 as 'TCP Established', percentile(ssl_handshake_done-tcp_established, 95) * 1000 as 'SSL Handshake', percentile(time_to_filetransfer_begin-ssl_handshake_done, 95) * 1000 as 'Time to Transfer' timeseries MAX"
              }
            ],
            "yAxisLeft": {
              "max": 1000,
              "min": 0.01,
              "zero": false
            }
          }
        },
        {
          "title": "Time to DNS resolution by hostname (ms)",
          "layout": {
            "column": 1,
            "row": 11,
            "width": 4,
            "height": 3
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
                "query": "From DiagnosticsCurl select percentile(dns_resolution, 95) * 1000 as 'DNS Resolution' timeseries MAX FACET hostname"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "Time to SSL handshake by hostname (ms)",
          "layout": {
            "column": 5,
            "row": 11,
            "width": 4,
            "height": 3
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
                "query": "From DiagnosticsCurl select percentile(ssl_handshake_done, 95) * 1000 as 'SSL Handshake' timeseries MAX FACET hostname"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "Time to first byte by hostname (ms)",
          "layout": {
            "column": 9,
            "row": 11,
            "width": 4,
            "height": 3
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
                "query": "From DiagnosticsCurl select percentile(time_to_filetransfer_begin, 95) * 1000 as 'Time to Transfer' timeseries MAX FACET hostname"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
            "yAxisLeft": {
              "zero": true
            }
          }
        },
        {
          "title": "",
          "layout": {
            "column": 1,
            "row": 14,
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
            "row": 15,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": null,
          "visualization": {
            "id": "viz.markdown"
          },
          "rawConfiguration": {
            "text": "Using DNS to find a server\n---\n* How long does it take to ask for our service by domain name?\n* Does it matter what DNS server we ask?\n* Does it matter where we are asking from?"
          }
        },
        {
          "title": "Number of runners",
          "layout": {
            "column": 5,
            "row": 15,
            "width": 4,
            "height": 3
          },
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTQ"
          ],
          "visualization": {
            "id": "viz.table"
          },
          "rawConfiguration": {
            "facet": {
              "showOtherSeries": false
            },
            "nrqlQueries": [
              {
                "accountId": 3367539,
                "query": "FROM DiagnosticsDig SELECT uniqueCount(primary_ip) FACET hostname"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            }
          }
        },
        {
          "title": "DNS lookup from dig (ms)",
          "layout": {
            "column": 9,
            "row": 15,
            "width": 4,
            "height": 3
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
                "query": "from DiagnosticsDig select percentile(query_time_ms, 95) facet hostname, dns_server_ip timeseries max"
              }
            ],
            "platformOptions": {
              "ignoreTimeRange": false
            },
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
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTU"
          ],
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
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTU"
          ],
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
          "linkedEntityGuids": [
            "MzM2NzUzOXxWSVp8REFTSEJPQVJEfDM5NjgyOTU"
          ],
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
          "title": "Packet loss (%)",
          "layout": {
            "column": 10,
            "row": 1,
            "width": 3,
            "height": 7
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
        },
        {
          "title": "Ping times (ms)",
          "layout": {
            "column": 1,
            "row": 4,
            "width": 9,
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
        }
      ]
    }
  ],
  "variables": []
}
```

### Credits

Thanks to the authors of these fabulous posts:
- How to get your wan ip via bash: https://unix.stackexchange.com/a/81699
-
