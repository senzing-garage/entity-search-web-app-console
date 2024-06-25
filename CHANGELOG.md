# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

-

## [1.1.8] - 2024-06-24

### Changed in 1.1.8

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.10.3`
- In `requirements.txt`, updated:
  - orjson==3.10.5
  - python-socketio==5.11.3
  - setuptools==70.1.0

## [1.1.7] - 2024-05-22

### Changed in 1.1.7

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.10.1`
- In `requirements.txt`, updated:
  - csvkit==2.0.0
  - Flask==3.0.3
  - orjson==3.10.3
  - pandas==2.2.2
  - prettytable==3.10.0
  - python-engineio==4.9.1
  - python-socketio==5.11.2
  - setuptools==70.0.0
  - VisiData==3.0.2

## [1.1.6] - 2023-09-30

### Changed in 1.1.6

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.7.1`
- In `requirements.txt`, updated:
  - Flask-SocketIO==5.3.6
  - Flask==2.3.3
  - orjson==3.9.7
  - pandas==2.1.1
  - prettytable==3.9.0
  - PySnooper==1.2.0
  - python-engineio==4.7.1
  - python-socketio==5.9.0
  - setuptools==68.2.2
  - VisiData==2.11.1

## [1.1.5] - 2023-05-09

### Changed in 1.1.5

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.5.2`
- In `requirements.txt`, updated:
  - Flask-SocketIO==5.3.3
  - Flask==2.2.3
  - orjson==3.8.9
  - pandas==1.5.3
  - prettytable==3.6.0
  - python-engineio==4.4.0
  - setuptools==67.6.1

## [1.1.4] - 2023-04-03

### Changed in 1.1.4

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.5.0`
- In `requirements.txt`, updated:
  - csvkit==1.1.1
  - Flask-SocketIO==5.3.3
  - Flask==2.2.3
  - orjson==3.8.9
  - pandas==1.5.3
  - prettytable==3.6.0
  - python-engineio==4.4.0
  - python-socketio==5.8.0
  - setuptools==67.6.1
  - VisiData==2.11

## [1.1.3] - 2022-10-27

### Changed in 1.1.3

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.3.2`
- In `requirements.txt`, updated:
  - orjson==3.8.1
  - pandas==1.5.1
  - prettytable==3.5.0
  - python-socketio==5.7.2
  - setuptools==65.5.0
  - VisiData==2.10.2

## [1.1.2] - 2022-09-28

### Changed in 1.1.2

- In `Dockerfile`, updated FROM instruction to `senzing/senzingapi-tools:3.3.0`
- In `requirements.txt`, updated:
  - setuptools==65.4.0

## [1.1.1] - 2022-09-23

### Changed in 1.1.1

- Migrated from pip `pyodbc` to apt `python3-pyodbc`
- In `Dockerfile`, updated to fio-3.30
- Trimmed `requirements.txt`
- Improved `README.md`

## [1.1.0] - 2022-08-26

### Changed in 1.1.0

- Docker image Base Image updated to use `senzingapi-tools@3.2.0`

## [1.0.0] - 2022-07-07

### Added in 1.0.0

- Initial public release.
- Includes all functionality necessary to invoke a web-based terminal from inside of the entity-web-search-app admin context.
- Supports `senzingdata-v3`

## [0.0.3] - 2022-05-04

### Changed in 0.0.3

- Last release supporting senzingdata-v2

## [0.0.2] - 2022-02-24

### Added in 0.0.2

- Initial work all done.
- It functionally works with the [github.com/Senzing/entity-search-web-app](https://github.com/senzing-garage/entity-search-web-app).
- When configured properly a new menu option called *Console* shows up in the admin menu.
- The page embeds a xterm console and the user can execute G2 python tools through the web interface.
