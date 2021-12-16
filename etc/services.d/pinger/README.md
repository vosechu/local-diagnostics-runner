# Pinger Script Info
**Gotcha warning:** This will log results every ten seconds **forever** if it is enabled. If adding to or altering this script, please make sure you understand how many logs per second you will be producing.

**How to disable:** see the [main readme](#how-to-disable-scripts) for how to disable locally.

Example output:
```json
{"eventType":"DiagnosticsDnsPing", "dns_server_pinged":"10.1.241.220", "time_ms":129, "packet_loss_percent":0}
```
## Hypothesis:
We want to know the speed of our DNS servers-- are they slow? We suspect they might be.

This script parses the data we collect from each ping to our DNS servers and sends it to New Relic. The hope is that this will provide us with much-needed observability, and the ability to answer the following questions:

* How fast are pings to DNS servers?
* Does it matter what Environment is pinging?
* Does it matter what datacenter?

## Methodology:
Before running the script, we check if the `DISABLE_*` environment variable in the container has a length of 0.
**Gotcha warning:** If it is set to `"true"`, the length is greater than 0, and the script is not run, which is the expected behavior-- however, since the logic is string length and not string content, you could also set it to "bananas" and get the same result.

We measure the time it takes for packets to be sent from the container to our DNS servers and back. We also measure the round-trip time of the packet and any losses along the way.

We perform a ping of our local DNS servers for information about host addresses, nameservers, and related information _every ten seconds_. We then store the results of that in a temp file so that we can extract various values from it.

We extract the time and packet loss percentage numbers using `grep` and `sed`.

We then add container deployment environment variables and send that to a temp file so that we can compress it when we send it to New Relic.

Lastly, we compress and then sendour temp file (with valid JSON formatting) to New Relic.
