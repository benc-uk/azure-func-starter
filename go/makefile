.DEFAULT_GOAL := help

help: ## 💬 This help message :)
	@figlet $@ || true
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

run: ## 🚀 Run the custom handler and local functions server
	go build -o ./bin/func-server ./src
	func start

clean: ## 🧹 Clean the project
	rm -rf ./bin

lint: ## 🚩 Lint the code
	golangci-lint run ./src/...

format: ## 🌈 Format the code
	gofmt -w ./src

check: ## 🧐 Check the code, to use in CI
	gofmt -l ./src | wc -l | grep 0
	golangci-lint run ./src/...