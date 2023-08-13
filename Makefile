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

BUILD_TIMESTAMP = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
BUILD_DATE = $(shell date -u +'%Y-%m-%d')
BUILD_DATE_TAG = $(shell date -u +'%Y%m%d')
TAG = $(BUILD_DATE_TAG)
BUILD_VERSION = 5.0.0.0
VCS_REF = $(shell git rev-parse HEAD)
TARGET_PLATFORMS = linux/amd64,linux/arm64
BUILDX_BUILDER = buildx-builder
DOCKER_EXTRA_FLAGS = --builder $(BUILDX_BUILDER) --platform $(TARGET_PLATFORMS) --build-arg BUILD_TIMESTAMP=$(BUILD_TIMESTAMP) --build-arg BUILD_DATE_TAG=$(BUILD_DATE) --build-arg VCS_REF=$(VCS_REF) --build-arg BUILD_VERSION=$(BUILD_VERSION)
DOCKER_PUSH =

all:
	BUILDKIT_PROGRESS=plain $(DOCKER) buildx build  $(DOCKER_EXTRA_FLAGS)  -f Dockerfile -t $(REGISTRY)/ci:$(TAG) . $(DOCKER_PUSH)
# --no-cache
ensure-builder:
	-$(DOCKER) buildx create --name $(BUILDX_BUILDER)

.PHONY: all ensure-builder
