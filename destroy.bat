@echo off

set PROJECT=%1
set ENV=%2

set TERRAFORM_PATH=%PROJECT%/stages/%ENV%
set CUSTOMER_BACKEND_PATH="%CD%/%PROJECT%/env/%ENV%/%ENV%.backend.tfvars"
set VAR_PATH="%CD%/%PROJECT%/env/%ENV%/%ENV%.tfvars"

terraform -chdir=%TERRAFORM_PATH% fmt -recursive
terraform -chdir=%TERRAFORM_PATH% init -backend-config=%CUSTOMER_BACKEND_PATH% -upgrade -migrate-state
terraform -chdir=%TERRAFORM_PATH% destroy -var-file=%VAR_PATH% -parallelism=2




