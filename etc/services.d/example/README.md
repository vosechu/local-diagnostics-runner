# How to use this template
The purpose of the template below is to add one into each directory you make for running a script. The hope is that you-of-three-months-from-now, your teammates, and other teams will all be super grateful that this exists and they don't have to spend hours figuring out what your script does.

---

## Script Info
This section is for:
* Giving a brief summary of your script
* Explaining how to run it/stop running it
* Providing example output/results (if relevant)

### Hypothesis:
This section should answer these questions:
1. What this script does, and why
1. What are some potential pitfalls of writing, adding to, or running this script?
1. With this script in place, what is the purpose of the results?

### Methodology:
This section should contain:
1. A detailed and thorough explanation of your code, with examples
1. Explanation of any "gotchas" or tricky logic in the code

---

## Protip! Here's how to send info to New Relic:
1. Place script results, formatted as valid JSON, into a temp file
1. With `gzip -c`, write on standard output; keep original files unchanged.
1. Pipe that to a curl that posts to the collector, which is specified in the `grandcentral.yml` file.
    * The `--data-binary` is used to post data exactly as specified with no extra processing whatsoever.

```
gzip -c $temp_file | curl -X POST -H "Content-Type: application/json" -H "X-Insert-Key: $EVENTS_INSERT_API_KEY" -H "Content-Encoding: gzip" $COLLECTOR_URL/v1/accounts/$ACCOUNT_ID/events --data-binary @-
```
