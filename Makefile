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

REGISTRY := docker.io/jeremyje
DOCKER := docker
DOCKER_TAG := latest

BUILD_TIMESTAMP = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_DATE = $(shell date -u +'%Y-%m-%d')
BUILD_DATE_TAG = $(shell date -u +'%Y%m%d')
BUILD_VERSION = 1.0.0
VCS_REF = $(shell git rev-parse HEAD)
IMAGE_BUILD_ARGS = --build-arg BUILD_TIMESTAMP=$(BUILD_TIMESTAMP) --build-arg BUILD_DATE_TAG=$(BUILD_DATE) --build-arg VCS_REF=$(VCS_REF) --build-arg BUILD_VERSION=$(BUILD_VERSION)

all: build-debian-image build-alpine-image

build-%-image:
	$(DOCKER) build . -f $*/Dockerfile $(IMAGE_BUILD_ARGS) -t $(REGISTRY)/ci:$*-$(BUILD_DATE_TAG) -t $(REGISTRY)/ci:$*-$(DOCKER_TAG) -t $(REGISTRY)/ci:$*-$(VCS_REF) -t $(REGISTRY)/ci:$*-$(BUILD_VERSION)

push: push-debian-image push-alpine-image

push-%-image: build-%-image
	$(DOCKER) push $(REGISTRY)/ci:$*-$(BUILD_DATE_TAG)
	$(DOCKER) push $(REGISTRY)/ci:$*-$(DOCKER_TAG)
	$(DOCKER) push $(REGISTRY)/ci:$*-$(VCS_REF)
	$(DOCKER) push $(REGISTRY)/ci:$*-$(BUILD_VERSION)

.PHONY: all push
