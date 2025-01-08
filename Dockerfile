ARG UBUNTU_VERSION="24.04"
ARG KSOPS_VERSION="4.3.2"

FROM viaductoss/ksops:v$KSOPS_VERSION AS ksops-builder
FROM ubuntu:$UBUNTU_VERSION AS base
LABEL org.opencontainers.image.source="https://github.com/csobrinho/sops-yubikey"

ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
    gnupg \
    gpg-agent \
    scdaemon \
    pcscd \
    pcsc-tools \
    libccid && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tools
COPY --from=ksops-builder /usr/local/bin/* .
