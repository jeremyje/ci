# Copyright 2023 Jeremy Edwards
#
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

FROM debian:latest
LABEL maintainer="http://www.futonredemption.com <jeremyje@gmail.com>"

RUN apt-get -qq -y update

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    nano \
    pkg-config \
    software-properties-common \
    sudo \
    unzip \
    zip \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker
# https://docs.docker.com/engine/install/debian/
RUN sudo install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && sudo chmod a+r /etc/apt/keyrings/docker.gpg \
  && echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN sudo apt-get update \
  && sudo apt-get -qq -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
