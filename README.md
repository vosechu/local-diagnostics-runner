# Diagnostic diagnostics-runners Runner
This repo represents a container and utility scripts for diagnostics-runnering and troubleshooting.


# How to run it:
Use our handy incantations:

**1. Build your docker image**
```
cp .env.example .env
docker build -f Dockerfile . --tag diagnostics-runner --target diagnostics-runner
```
## Locally reporting to New Relic NRDB

**2. Make/copy your NRDB insert key**

Go to [API Keys](https://one.newrelic.com/launcher/api-keys-ui.launcher?pane=eyJuZXJkbGV0SWQiOiJhcGkta2V5cy11aS5ob21lIn0=), then click on "New Relic insert keys".

Put this file into your `.env` file.

**3. Run (after the building step)**

```
docker run -it --rm --env-file=.env -e OUTER_HOSTNAME=$HOST diagnostics-runner
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
DOCKER_HOST="ssh://pi@raspberrypi.local" docker build -f Dockerfile . --tag diagnostics-runner --target diagnostics-runner
DOCKER_HOST="ssh://pi@raspberrypi.local" docker run -it --rm diagnostics-runner
```

### Credits

Thanks to the authors of these fabulous posts:
- How to get your wan ip via bash: https://unix.stackexchange.com/a/81699
-
