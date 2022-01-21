ARG BASE_IMAGE=senzing/senzing-base:1.6.4
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2022-01-06

LABEL Name="senzing/entity-search-web-app-console" \
      Maintainer="support@senzing.com" \
      Version="0.0.1"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
    build-essential \
    elfutils \
    fio \
    htop \
    iotop \
    ipython3 \
    itop \
    less \
    libpq-dev \
    net-tools \
    odbc-postgresql \
    procps \
    pstack \
    python-dev \
    python-pyodbc \
    python-setuptools \
    strace \
    telnet \
    tree \
    unixodbc \
    unixodbc-dev \
    vim \
    zip

# Install Nodejs
RUN apt-get -y install curl software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get -yq install \
    nodejs \
 && npm install -g npm \
 && node -v

# Remove old lists
RUN rm -rf /var/lib/apt/lists/*

# Install packages via pip.

COPY requirements.txt ./
RUN pip3 install --upgrade pip \
 && pip3 install -r requirements.txt \
 && rm requirements.txt

# Copy files from repository.
COPY ./rootfs /
COPY ./run /app/run
COPY package.json /app
COPY package-lock.json /app

# Install packages via npm
WORKDIR /app
#RUN npm install -g npm
RUN npm i --production

# update npm vulnerabilites
#RUN npm -g uninstall npm
#RUN rm -fr /usr/local/lib/node_modules/npm

# Make non-root container.

RUN addgroup --gid 1004 consoleusers \
    && useradd -u 1001 -g 1004 -m senzing -s /bin/bash
USER 1001

# Runtime execution.
WORKDIR /app
ENTRYPOINT [ "node" ]
CMD ["./run/xterm"]
#CMD ["/app/sleep-infinity.sh"]
