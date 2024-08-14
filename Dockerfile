# syntax = docker/dockerfile:experimental
FROM --platform=linux/arm/v5 python:3.12-bullseye
ARG NUMPY_VER
ARG CRYPTOGRAPHY_VER

RUN echo "deb http://deb.debian.org/debian experimental main contrib non-free" >> /etc/apt/sources.list
RUN apt update && DEBIAN_FRONTEND=noninteractive && apt install -y jq curl rustc build-essential cmake --no-install-recommends
RUN wget $(curl --silent https://api.github.com/repos/rara64/armv5te-cargo/releases/latest | jq -r '.assets[0].browser_download_url')
RUN dpkg -i *.deb

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN --security=insecure mkdir -p /root/.cargo/registry && chmod 777 /root/.cargo/registry && mount -t tmpfs none /root/.cargo/registry && pip install \
numpy==$NUMPY_VER \
cryptography==$CRYPTOGRAPHY_VER \
--no-deps
