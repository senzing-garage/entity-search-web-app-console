ARG BASE_IMAGE=senzing/senzingapi-tools:3.2.0

# -----------------------------------------------------------------------------
# Stage: builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} AS builder

# Set Shell to use for RUN commands in builder step.

ENV REFRESHED_AT=2022-08-25

LABEL Name="senzing/entity-search-web-app-console" \
      Maintainer="support@senzing.com" \
      Version="1.1.0"

# Run as "root" for system installation.

USER root

# Install packages via apt for building fio.

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
 && wget https://github.com/axboe/fio/archive/refs/tags/fio-3.27.zip \
 && unzip fio-3.27.zip \
 && cd fio-fio-3.27/ \
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

ENV REFRESHED_AT=2022-08-25

LABEL Name="senzing/entity-search-web-app-console" \
      Maintainer="support@senzing.com" \
      Version="1.1.0"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      curl \
      elvis-tiny \
      htop \
      iotop \
      jq \
      less \
      libpq-dev \
      libssl1.1 \
      net-tools \
      odbcinst \
      openssh-server \
      postgresql-client \
      procps \
      python3-dev \
      python3-pip \
      sqlite3 \
      strace \
      tree \
      unixodbc-dev \
      unzip \
      wget \
      zip \
 && apt-get clean

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
#RUN npm install -g npm
RUN npm i --production

# Runtime environment variables.

ENV LANGUAGE=C
ENV LC_ALL=C.UTF-8
ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV PYTHONUNBUFFERED=1
ENV SENZING_DOCKER_LAUNCHED=true
ENV SENZING_ETC_PATH=/etc/opt/senzing
ENV SENZING_SKIP_DATABASE_PERFORMANCE_TEST=true
ENV SENZING_SSHD_SHOW_PERFORMANCE_WARNING=true
ENV TERM=xterm

# Make non-root container.

RUN addgroup --gid 1004 consoleusers \
    && useradd -u 1001 -g 1004 -m senzing -s /bin/bash
USER 1001

# Runtime execution.
WORKDIR /app
ENTRYPOINT [ "node" ]
CMD ["./run/xterm"]