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

FROM alpine:3
ARG CLOUD_SDK_VERSION=301.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV CLOUDSDK_PYTHON=python3

# https://pkgs.alpinelinux.org/packages
# hadolint ignore=DL3018
RUN apk --no-cache add git make python3 py3-virtualenv py3-crcmod curl sudo unzip ca-certificates docker gnupg libc6-compat jq

# Cloud SDK (https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/alpine/Dockerfile)
ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && gcloud config set core/disable_usage_reporting true \
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
ENV CI_MODE=1
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
    org.opencontainers.image.title="Continuous Integration (Alpine)" \
    org.opencontainers.image.description="Continuous Integration (Alpine)" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE_TAG}" \
    org.label-schema.url="https://github.com/jeremyje/ci" \
    org.label-schema.vcs-url="https://github.com/jeremyje/ci" \
    org.label-schema.version="${BUILD_VERSION}" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vendor="Continuous Integration" \
    org.label-schema.name="Continuous Integration (Alpine)" \
    org.label-schema.description="AContinuous Integration (Alpine)" \
    org.label-schema.usage="https://github.com/jeremyje/ci"
