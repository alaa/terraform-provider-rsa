# Author: Alaa Qutaish
# terraform-provider-rsa

GOOS ?= "linux" # Possible options: darwin, freebsd, linux, netbsd, openbsd, solaries, windows, plan9.
GOARCH ?= "amd64" # Possible options: arm, 386, amd64, mips, mipsle, mips64, mips64le.

TF_PLUGIN_DIR = `echo "${HOME}/.terraform.d/plugins/${GOOS}_${GOARCH}" | tr -d ' '`
TF_PROVIDER_NAME = "terraform-provider-rsa"

.PHONY: deps build test clean

.DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%30s\033[0m : %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: cmd-go ## Setup Go packages dependecies.
	@go mod init github.com/alaa/terraform-provider-rsa
	@go mod tidy
	@go mod verify

build: cmd-go ## Compile Terraform Provider.
	@mkdir -p ${TF_PLUGIN_DIR}
	@env GOOS=${GOOS} GOARCH=${GOARCH} go build -o ${TF_PLUGIN_DIR}/${TF_PROVIDER_NAME}

test: cmd-terraform ## Load the terraform provider using `terraform init`.
	@terraform init examples
	@terraform plan -state examples/terraform.tfstate -out examples/terraform.plan examples
	@terraform apply --auto-approve -state=examples/terraform.tfstate examples/terraform.plan

clean: cmd-terraform ## Clean test state and plan files.
	@rm -f examples/terraform.plan
	@rm -f examples/terraform.tfstate
	@rm -f examples/terraform.tfstate.backup
	@rm -f go.mod
	@rm -f go.sum

cmd-%: # Check that a command exists.
	@: $(if $$(command -v ${*} 2>/dev/null),,$(error Please install "${*}" first))
