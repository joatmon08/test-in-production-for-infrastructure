fmt:
	terraform fmt
	terraform validate

install:
	terraform init

unit:
	terraform validate
	terraform fmt

plan:
	terraform plan

apply:
	terraform apply

integration: apply
	kitchen test

clean:
	terraform destroy --force  || true