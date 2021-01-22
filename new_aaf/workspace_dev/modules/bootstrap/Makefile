#Makefile
.PHONY: prep plan deploy destroy all bootstrap
REGION ?= us-east-1
TF_OUT_PLAN := ./tf.out
ENVIRONMENT_NAME ?= undefined
TF_REMOTE := ../../config/$(REGION)/$(ENVIRONMENT_NAME)/remote.tfvars
TF_CONFIG := ../../config/$(REGION)/$(ENVIRONMENT_NAME)/bootstrap.tfvars



all: prep plan deploy

set-env:
	@if [ $(ENVIRONMENT_NAME) == "undefined" ]; then \
		printf "\n$(BOLD)$(GREEN)***Please set the AWS account name - (ENVIRONMENT_NAME=pprd-aric)!!***$(RESET)\n\n"; \
		ERROR=1;\
		exit 1;\
	fi


prep:
	# @if [ -d .terraform ] ; then \
	# 	rm -fr .terraform ; \
	# fi
	tfenv install
	@terraform init -backend-config=$(TF_REMOTE)



plan: prep
	@terraform plan -var-file=$(TF_CONFIG) -out=$(TF_OUT_PLAN)

bootstrap:
	@terraform init
	@terraform plan -var-file=$(TF_CONFIG) -out=$(TF_OUT_PLAN)

lock:
	terraform apply -target aws_dynamodb_table.dynamodb-terraform-state-lock -lock=false -auto-approve

# $(TF_OUT_PLAN): plan

deploy: $(TF_OUT_PLAN)
	terraform apply $(TF_OUT_PLAN)
	@if [ -f "$(TF_OUT_PLAN)" ] ; then \
		rm -f "$(TF_OUT_PLAN)"; \
	fi

check: prep
	terraform plan -detailed-exitcode

destroy: prep
	terraform destroy -var-file=$(TF_CONFIG)

docs:
	terraform-docs md . > README.md

valid:
	tflint
	terraform fmt -check=true -diff=true
