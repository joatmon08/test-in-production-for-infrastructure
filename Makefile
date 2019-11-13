SETUP := aws-vault exec rosemary.demos --

fmt:
	terraform fmt
	terraform validate

install:
	terraform init

unit:
	terraform validate
	terraform fmt

plan:
	$(SETUP) terraform plan

apply:
	$(SETUP) terraform apply

integration: apply
	$(SETUP) kitchen test

clean:
	$(SETUP) terraform destroy --force  || true