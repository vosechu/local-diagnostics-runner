# Curler Script Info
**Gotcha warning:** This will log results every ten seconds **forever** if it is enabled. If adding to or altering this script, please make sure you understand how many logs per second you will be producing.

**How to disable:** see the [main readme](#how-to-disable-scripts) for how to disable locally.

Example output:

```json
{ "eventType":"LocalDiagnosticsAuthCheck", "dns_resolution": 0.230948, "tcp_established": 0.000354, "time_appconnect":  0.000221, "ssl_handshake_done": 0.8823, "time_to_filetransfer_begin": 0.0987, "httpResponseCode": 200, "local_ip": "10.1.241.220", "remote_ip": "8.8.8.8", "num_connects": 1, "num_redirects": 1 }
```

## Hypothesis:
We want to know if, when we're connecting to an arbitrary server, is the connection slow?

This script parses the data we collect from each curl to that server and sends it to New Relic. The hope is that this will provide us with much-needed observability, and the ability to answer the following questions:

* How quickly are we connecting to that server?
* How fast are each of the connection events?
* Is any part of connect taking particularly long at a particular location?

## Methodology:
Before running the script, we check if the `DISABLE_CURLER` environment variable in the container has a length of 0.
**Gotcha warning:** If it is set to `"true"`, the length is greater than 0, and the script is not run, which is the expected behavior-- however, since the logic is string length and not string content, you could also set it to "bananas" and get the same result.

We perform an HTTP check _every ten seconds_ by curling `$URL`. We format the response as valid JSON, add container environment variables and send that to a temp file so that we can compress it when we send it to New Relic.

Lastly, we compress and then send our temp file (with valid JSON formatting) to New Relic.
