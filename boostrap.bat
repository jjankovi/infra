@echo off

set TERRAFORM_PATH=tf_bootstrap
set CUSTOMER_BACKEND_PATH=%CD%/tf_bootstrap\backend.tfvars


terraform -chdir=%TERRAFORM_PATH% fmt -recursive
terraform -chdir=%TERRAFORM_PATH% init -backend-config=%CUSTOMER_BACKEND_PATH% -upgrade -migrate-state
@REM init -upgrade -migrate-state
terraform -chdir=%TERRAFORM_PATH% apply -parallelism=2




