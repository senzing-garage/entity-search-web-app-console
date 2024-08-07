ARG BASE_IMAGE=senzing/senzingapi-tools:3.10.3
ARG BASE_BUILDER_IMAGE=node:lts-buster-slim

ARG IMAGE_NAME="senzing/entity-search-web-app-console"
ARG IMAGE_MAINTAINER="support@senzing.com"
ARG IMAGE_VERSION="1.1.8"

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_BUILDER_IMAGE} AS builder

# Set Shell to use for RUN commands in builder step.

ENV REFRESHED_AT=2024-06-24

# Run as "root" for system installation.

USER root

# Set working directory.

WORKDIR /app

# Add `/app/node_modules/.bin` to $PATH

ENV PATH /app/node_modules/.bin:$PATH

# Install and cache app dependencies.

COPY package.json      /app/package.json
COPY package-lock.json /app/package-lock.json

# Build js packages.

# Currently there is no reason to do this step
# But there will be once ticket #17 is done
# RUN npm config set loglevel warn \
# && npm i --production
# && npm run build

# Install packages via apt for building fio.

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y install \
  gcc \
  make \
  pkg-config \
  unzip \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Work around until Debian repos catch up to modern versions of fio.

RUN mkdir /tmp/fio \
  && cd /tmp/fio \
  && wget https://github.com/axboe/fio/archive/refs/tags/fio-3.30.zip \
  && unzip fio-3.30.zip \
  && cd fio-fio-3.30/ \
  && ./configure \
  && make \
  && make install \
  && fio --version \
  && cd \
  && rm -rf /tmp/fio

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE} AS runner

ENV REFRESHED_AT=2024-06-24

LABEL Name=${IMAGE_NAME} \
  Maintainer=${IMAGE_MAINTAINER} \
  Version=${IMAGE_VERSION}

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y install \
  elvis-tiny \
  htop \
  iotop \
  jq \
  less \
  net-tools \
  openssh-server \
  postgresql-client \
  procps \
  python3-dev \
  python3-pip \
  python3-pyodbc \
  software-properties-common \
  strace \
  tree \
  unzip \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

# Install Nodejs

RUN wget -q -O - https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get -yq install \
  nodejs \
  && node -v

# Install packages via pip.

COPY requirements.txt .
RUN pip3 install --upgrade pip \
  && pip3 install -r requirements.txt \
  && rm /requirements.txt

# Copy files from repository.

COPY ./rootfs /
COPY ./run /app/run
COPY package.json /app
COPY package-lock.json /app

# Copy files from prior stages.

COPY --from=builder "/usr/local/bin/fio" "/usr/local/bin/fio"

# Install packages via npm
WORKDIR /app
RUN npm i --production

# The port for the Flask is 5000.

EXPOSE 5000

# Make non-root container.

RUN addgroup --gid 1004 consoleusers \
  && useradd -u 1001 -g 1004 -m senzing -s /bin/bash

USER 1001

# Runtime environment variables.

ENV LC_ALL=C.UTF-8 \
  LC_CTYPE=C.UTF-8 \
  SENZING_SSHD_SHOW_PERFORMANCE_WARNING=true

# Runtime execution.
WORKDIR /app
ENTRYPOINT [ "node" ]
CMD ["./run/xterm"]
