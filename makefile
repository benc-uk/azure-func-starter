# Only used for deployment to Azure and building the docker image

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

SUB_PROJECT ?= typescript

# Override these if building your own images
IMAGE_REG ?= ghcr.io
IMAGE_NAME ?= benc-uk/functions-$(SUB_PROJECT)
IMAGE_TAG ?= latest

AZ_REGION ?= uksouth
AZ_DEPLOY_NAME ?= deploy-$(SUB_PROJECT)

.PHONY: build

build:
	docker build -t $(IMAGE_REG)/$(IMAGE_NAME):$(IMAGE_TAG) ./$(SUB_PROJECT)

push:
	docker push $(IMAGE_REG)/$(IMAGE_NAME):$(IMAGE_TAG)

deploy-typescript-code:
	@cd $(SUB_PROJECT); npm run build
	az deployment sub create --name $(AZ_DEPLOY_NAME) --location $(AZ_REGION) --template-file ./deploy/consumption.bicep --param appName=$(AZ_DEPLOY_NAME)
	@sleep 5
	$(eval FUNC_APP_NAME = $(shell az deployment sub show --name $(AZ_DEPLOY_NAME) --query properties.outputs.functionAppName.value -o tsv))
	@cd $(SUB_PROJECT); func azure functionapp publish $(FUNC_APP_NAME)

deploy-container: build push
	@az deployment sub create --name $(AZ_DEPLOY_NAME) \
	  --location uksouth --template-file ./deploy/container-app.bicep \
	  --parameters appName=$(AZ_DEPLOY_NAME) imageRegistry=$(IMAGE_REG) imageTag=$(IMAGE_TAG) imageRepo=$(IMAGE_NAME) \
		--query properties.provisioningState -o table