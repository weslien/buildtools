# Override these by setting them in the environment
ARCHITECTURES ?= aarch64 arm64 amd64
GITHUB_ORG ?= weslien
IMAGE_NAME ?= buildtools
DOCKER_USERNAME ?= weslien
DOCKER_PAT ?= ""

.PHONY: all _auth
build:
	for ARCH in $(ARCHITECTURES); do \
		echo "Building for $$ARCH"; \
		docker buildx build --platform linux/$$ARCH -t $(GITHUB_ORG)/$(IMAGE_NAME):$$ARCH-latest .; \
	done
push: _auth
	for ARCH in $(ARCHITECTURES); do \
		echo "Pushing for $$ARCH"; \
		docker push $(GITHUB_ORG)/$(IMAGE_NAME):$$ARCH-latest; \
	done
	
_auth:
	docker login  -u $(DOCKER_USERNAME) -p $(DOCKER_PAT)