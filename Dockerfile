FROM ubuntu:24.04 AS base

LABEL org.opencontainers.image.source="https://github.com/csobrinho/sops-yubikey"

ENV DEBIAN_FRONTEND=noninteractive
ENV GPG_PASSPHRASE=123456

USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    s6 \
    gnupg \
    gpg-agent \
    scdaemon \
    pcscd \
    pcsc-tools \
    libccid \
    usbutils \
    lshw && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root

COPY .gnupg .gnupg
RUN chmod 700 .gnupg && \
    chmod 600 .gnupg/*

WORKDIR /
COPY services.d /etc/services.d
RUN chmod +x /etc/services.d/*/run && \
    chmod +x /etc/services.d/*/check && \
    chmod +x /etc/services.d/*/finish

COPY run.sh /root/run.sh
RUN chmod +x /root/run.sh

# ENTRYPOINT ["/usr/bin/s6-svscan", "/etc/services.d"]
ENTRYPOINT ["/root/run.sh"]
