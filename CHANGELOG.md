# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
[markdownlint](https://dlaa.me/markdownlint/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

-

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
- It functionally works with the [github.com/Senzing/entity-search-web-app](https://github.com/Senzing/entity-search-web-app).
- When configured properly a new menu option called *Console* shows up in the admin menu.
- The page embeds a xterm console and the user can execute G2 python tools through the web interface.
