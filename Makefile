.PHONEY = help install install_pips watch test

ifeq ($(OS),Windows_NT)
    venv_pip_path := venv/Scripts/pip
    venv_pip_alt := venv/Scripts/python -m pip
    venv_python_path := venv/Scripts/python
    venv_watchmedo_path := venv/Scripts/watchmedo
    virtualenv_path := ${python_path} -m virtualenv
else
    python_path := $(shell which python2.7 || which python)
    venv_pip_path := ./venv/bin/pip
    venv_pip_alt := ./venv/bin/python -m pip
    venv_python_path := ./venv/bin/python
    venv_watchmedo_path := ./venv/bin/watchmedo
    venv_yamllint_path := ./venv/bin/yamllint
    virtualenv_path := virtualenv
endif

ansible_cmd = $(venv_ansible_playbook_path)

help: ## this help text
	@echo 'Available targets'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# environment
install: | venv install_pips

venv: ## create virtual environment
	$(virtualenv_path) venv --python $(python_path)

install_pips: ## install pip requirements
	$(venv_pip_path) install pip -I || $(venv_pip_alt) install pip -I
	$(venv_pip_path) install --exists-action w -r requirements.txt || $(venv_pip_alt) install --exists-action w -r requirements.txt

# dev
watch: ## watch file-system changes to trigger a command
	$(venv_watchmedo_path) shell-command --patterns="${pattern}" --recursive --command="${command}" .

# run

# tests
test: | yaml_lint ## test all the things

yaml_lint: ## lint all yaml files
	$(venv_yamllint_path) .

# git
setup_hooks: ## setup git hooks for local development
	ln -fs ../../git-hooks/pre-commit.sh .git/hooks/pre-commit
	ln -fs ../../git-hooks/pre-push.sh .git/hooks/pre-push
