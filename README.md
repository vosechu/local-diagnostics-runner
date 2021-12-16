# Diagnostic diagnostics-runners Runner
This repo represents a container and utility scripts for diagnostics-runnering and troubleshooting.


# How to run it:
Use our handy incantations:

**1. Build and tag as diagnostics-runner**
```
docker build -f Dockerfile . --tag diagnostics-runner --target diagnostics-runner
```
**2. Run**
```
docker run -it --rm diagnostics-runner
```
## Locally reporting to New Relic NRDB

**2. Make/copy your NRDB insert key**

Go to [API Keys](https://one.newrelic.com/launcher/api-keys-ui.launcher?pane=eyJuZXJkbGV0SWQiOiJhcGkta2V5cy11aS5ob21lIn0=), then click on "New Relic insert keys".

**3. Run (after the building step)**

```
docker run -e EVENTS_INSERT_API_KEY=<THE FANCY INSERT KEY> -it --rm diagnostics-runner
```

**Protip**: if you want to add more variables to docker, add each one using

```
-e <VARIABLE NAME>=<VALUE>
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
