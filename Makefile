ARCHITECTURES = x86_64 aarch64 arm64 amd64
GITHUB_ORG = "weslien"
IMAGE_NAME = "buildtools"
DOCKER_USERNAME ?= weslien
DOCKER_PAT ?= ""

.PHONY: all
all: _auth
	for ARCH in $(ARCHITECTURES); do \
		echo "Building for $$ARCH"; \
		docker buildx build --platform linux/$$ARCH -t $(GITHUB_ORG)/$(IMAGE_NAME):$$ARCH-latest . --push; \
	done

_auth:
	docker login  -u $(DOCKER_USERNAME) -p $(DOCKER_PAT)