# entity-search-web-app-console

## Synopsis

The `senzing/entity-search-web-app-console` docker image is used for creating
a running Docker container configured to run Senzing programs and utilities through the entity-search-web-app's xterm console. For security and modularity reasons the web based console is a separate container from the webapp itself.

## Overview

The default behavior when running `docker run` is for the container to spin up a PTY and serve up a bidirection websocket server to allow the webapp to send and recieve input to that PTY.