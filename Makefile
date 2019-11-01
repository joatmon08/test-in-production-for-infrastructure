SETUP := aws-vault exec rosemary.training --

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