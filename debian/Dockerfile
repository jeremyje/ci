# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
# hadolint ignore=DL3008,DL3015
RUN apt-get install -y -qq gcc git make python3 virtualenv curl sudo unzip apt-transport-https ca-certificates curl software-properties-common gnupg2 jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Docker
# hadolint ignore=DL4006
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    buster \
    stable"

# Cloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-buster" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y -qq --no-install-recommends docker-ce docker-ce-cli containerd.io google-cloud-sdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Post install Cloud SDK
RUN gcloud config set core/disable_usage_reporting true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud --version

# Install Golang
# https://github.com/docker-library/golang/blob/fd272b2b72db82a0bd516ce3d09bba624651516c/1.12/stretch/Dockerfile
RUN mkdir -p /toolchain/golang
WORKDIR /toolchain/golang
RUN rm -rf /usr/local/go/
RUN curl -o go-linux.tar.gz -L https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz \
    && tar xzf go-linux.tar.gz -C /usr/local \
    && rm -f go-linux.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH"

# Prepare toolchain and workspace
RUN mkdir -p /toolchain

WORKDIR /workspace
ENV CI_IMAGE_MODE=1
ENV KUBECONFIG="$HOME/.kube/config"
RUN mkdir -p "$HOME/.kube/"

# Docker Image Arguments
ARG BUILD_TIMESTAMP
ARG BUILD_DATE_TAG
ARG VCS_REF
ARG BUILD_VERSION

# Standardized Docker Image Labels
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL \
    org.opencontainers.image.created="${BUILD_TIMESTAMP}" \
    org.opencontainers.image.authors="Continuous Integration" \
    org.opencontainers.image.url="https://github.com/jeremyje/ci" \
    org.opencontainers.image.documentation="https://github.com/jeremyje/ci" \
    org.opencontainers.image.source="https://github.com/jeremyje/ci" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.revision="1" \
    org.opencontainers.image.vendor="Continuous Integration" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.ref.name="" \
    org.opencontainers.image.title="Continuous Integration (Debian)" \
    org.opencontainers.image.description="Continuous Integration (Debian)" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE_TAG}" \
    org.label-schema.url="https://github.com/jeremyje/ci" \
    org.label-schema.vcs-url="https://github.com/jeremyje/ci" \
    org.label-schema.version="${BUILD_VERSION}" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vendor="Continuous Integration" \
    org.label-schema.name="Continuous Integration (Debian)" \
    org.label-schema.description="AContinuous Integration (Debian)" \
    org.label-schema.usage="https://github.com/jeremyje/ci"
