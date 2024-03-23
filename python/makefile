.DEFAULT_GOAL := help

help: ## 💬 This help message :)
	@figlet $@ || true
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

PYTHON_BIN := $(shell which python3.11)

run: .venv ## 🚀 Run the local functions server
	@func start

clean: ## 🧹 Clean the project
	@rm -rf ./.venv

lint: .venv ## 🚩 Lint check the code
	@. .venv/bin/activate; flake8 *.py handlers/*.py
	@echo "🎉 Lint check passed"

format: .venv ## 🌈 Format the code
	@. .venv/bin/activate; black -l 88 --preview *.py handlers/*.py

format-check: .venv ## 🌈 Check the format of the code
	@. .venv/bin/activate; black --check *.py handlers/*.py

check: lint format-check ## 🧐 Check the code, to use in CI

# ==== Makefile magic below here for virtualenv ====

.venv: .venv/touchfile

.venv/touchfile: requirements.txt
	@test -d .venv || $(PYTHON_BIN) -m venv .venv
	@. .venv/bin/activate; pip install -Ur requirements.txt
	@touch .venv/touchfile
