.PHONY: init
init:
	tofu init -var-file=prod.tfvars -migrate-state

.PHONY: plan
plan:
	tofu plan -var-file=prod.tfvars

.PHONY: apply
apply:
	tofu apply -var-file=prod.tfvars

.PHONY: destroy
destroy:
	tofu destroy -var-file=prod.tfvars

.PHONY: output-ip
output-ip:
	@echo "Sites Static IP Address:"
	@tofu output -var-file=prod.tfvars sites_static_ip_address