# Override these by setting them in the environment
ARCHITECTURES ?= linux/arm64,linux/amd64
GITHUB_ORG ?= weslien
IMAGE_NAME ?= buildtools
DOCKER_USERNAME ?= weslien
DOCKER_PAT ?= 
REV := $(shell git rev-parse --short HEAD)
BUILDER ?= ""

.PHONY: all _auth
build: _choose_builder
	
	@echo "Building for $(ARCHITECTURES) using $(BUILDER)"
	@docker buildx build --builder $(BUILDER) --platform $(ARCHITECTURES) -t "$(GITHUB_ORG)/$(IMAGE_NAME):latest"  . 
	@docker tag "$(GITHUB_ORG)/$(IMAGE_NAME):latest" "$(GITHUB_ORG)/$(IMAGE_NAME):$(REV)"

_choose_builder:
	@if [ "$(BUILDER)" == "" ]; then \
		echo "Enter the name of the builder to use:"; \
		docker buildx ls | grep -oE '^[a-zA-Z0-9_-]+' | grep -v NAME; \
		read -r builder; \
		export BUILDER=$$builder; \
	fi
push: _auth
	
	echo "Pushing for $$ARCH"; \
	
	docker push $(GITHUB_ORG)/$(IMAGE_NAME):latest; \
	docker push $(GITHUB_ORG)/$(IMAGE_NAME):$(REV); \
	

_auth:
	docker login  -u $(DOCKER_USERNAME) -p $(DOCKER_PAT)

test:
	docker run -i $(GITHUB_ORG)/$(IMAGE_NAME) echo "Hello World" | lcat
	docker run -i $(GITHUB_ORG)/$(IMAGE_NAME) echo "Hello World" | figlet
	docker run -i $(GITHUB_ORG)/$(IMAGE_NAME) npm
interactive:
	docker run -it $(GITHUB_ORG)/$(IMAGE_NAME)