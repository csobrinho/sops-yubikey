FROM ubuntu:24.04 AS base

LABEL org.opencontainers.image.source="https://github.com/csobrinho/sops-yubikey"

ENV DEBIAN_FRONTEND=noninteractive
ENV GPG_PASSPHRASE=123456

USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
    tini \
    gnupg \
    gpg-agent \
    scdaemon \
    pcscd \
    pcsc-tools \
    libccid \
    lsusb \
    lshw && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root

COPY . .
RUN chmod 700 .gnupg
RUN chmod 600 .gnupg/*
RUN chmod +x run.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/root/run.sh"]
