# syntax = docker/dockerfile:experimental
FROM --platform=linux/arm/v5 debian:sid
ARG NUMPY_VER
ARG CRYPTOGRAPHY_VER

RUN apt update && DEBIAN_FRONTEND=noninteractive && apt install -y curl wget jq
RUN wget $(curl --silent https://api.github.com/repos/rara64/armv5te-cargo/releases/latest | jq -r '.assets[0].browser_download_url')
RUN apt install -y build-essential cmake rustc python3.12
RUN dpkg -i *.deb

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN --security=insecure mkdir -p /root/.cargo/registry && chmod 777 /root/.cargo/registry && mount -t tmpfs none /root/.cargo/registry && pip install \
numpy==$NUMPY_VER \
cryptography==$CRYPTOGRAPHY_VER \
--no-deps
