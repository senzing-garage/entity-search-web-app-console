# entity-search-web-app-console

## Synopsis

The `senzing/entity-search-web-app-console` docker image is used for creating
a running Docker container configured to run Senzing programs and utilities through the entity-search-web-app's xterm console(/admin/console). For security and modularity reasons the web based console is a separate container from the webapp itself.

## Overview

The default behavior when running `docker run` is for the container to spin up a PTY and serve up a bidirection websocket server to allow the webapp to send and recieve input to that PTY.

### Prerequisite software

The following software programs need to be installed:

1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)
2. [docker-compose](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker-compose.md)

### Pull latest docker images

1. Pull the latest release of this app from [Docker Hub](https://hub.docker.com/r/senzing/entity-search-web-app-console).
   Example:

    ```console
    sudo docker pull senzing/entity-search-web-app-console
    ```

### Configuration

#### Environment Variables

    - `SENZING_CONSOLE_SERVER_PORT` is the port to run the xterm server on.
    - `SENZING_CONSOLE_SERVER_URL` is the full url that the console server should respond to. 
       So if your console server is running on port `2370` it would be `https://mydomain:2730`. If you are running behind a virtual path like `/app/console` it would be `https://mydomain:2730/app/console`. This variable has to be mirrored in the configuration of the (entity-search-web-app)[https://github.com/Senzing/entity-search-web-app] configuration. If misconfigured the console functionality will not be available in the UI.

#### Cmdline Switches

    - `webServerPortNumber` is the port to run the xterm server on.
    - `confServerPortNumber` is the full url that the console server should respond to. 
       So if your console server is running on port `2370` it would be `https://mydomain:2730`. If you are running behind a virtual path like `/app/console` it would be `https://mydomain:2730/app/console`. This variable has to be mirrored in the configuration of the (entity-search-web-app)[https://github.com/Senzing/entity-search-web-app] configuration. If misconfigured the console functionality will not be available in the UI.

### Air Gapped Environments

Obviously if your deployment environment is highly restricted you're probably going
to run in to issues downloading the latest images from that context.
Please refer to
"[Install docker image in an air-gapped environment](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker-image-in-air-gapped-enviroment.md)"
for how to procedure regarding this use-case.

The short version is find a machine with network access, then:

1. Pull the docker images you need to that machine.
2. Package them as a tar file. Example:

    ```console
    sudo docker save senzing/entity-search-web-app-console --output senzing-entity-search-web-app-console-latest.tar
    ```

3. Copy that to the deployment machine.
4. Load via

    ```console
    sudo docker load --input senzing-entity-search-web-app-console-latest.tar
    ```