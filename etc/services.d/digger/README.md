# Digger Script Info
**Gotcha warning:** This will log results every ten seconds **forever** if it is enabled. If adding to or altering this script, please make sure you understand how many logs per second you will be producing.

**How to disable:** see the [main readme](#how-to-disable-scripts) for how to disable locally.

Example output:
```json
{"eventType":"DiagnosticsDig", "dns_server_ip":"192.168.65.5", "response_ip":"10.1.221.212", "query_time_ms":0.21, "response_name":"" }
```
## Hypothesis:
We want to know if, when we're asking what the server is, is the connection slow? We suspect it might be.

This script parses the data we collect from each dig to the server and sends it to New Relic. The hope is that this will provide us with much-needed observability, and the ability to answer the following questions:

* How long does it take to ask this service by domain name?
* Does it matter what DNS server we ask?
* Does it matter where we are asking from?

## Methodology:
Before running the script, we check if the `DISABLE_*` environment variable in the container has a length of 0.
**Gotcha warning:** If it is set to `"true"`, the length is greater than 0, and the script is not run, which is the expected behavior-- however, since the logic is string length and not string content, you could also set it to "bananas" and get the same result.

We perform a query of our DNS nameserver for information about host addresses, nameservers, and related information _every ten seconds_ by `dig`ing `$URL`. We then store the results of that in a temp file so that we can extract various values from it.

We extract the response name, the response ip address, the query time, and the dns server's ip address using `grep` and `sed`.

We then add container deployment environment variables and send that to a temp file so that we can compress it when we send it to New Relic.

Lastly, we compress and then sendour temp file (with valid JSON formatting) to New Relic.
