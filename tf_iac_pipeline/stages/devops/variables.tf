variable "project_name" {
  description = "Unique name for this project"
  type        = string
  default     = "obi-iac"
}

variable "environment" {
  description = "Environment in which the script is run. Eg: devops, dev, prod, etc"
  type        = string
  default     = "devops"
}

variable "kms_enabled" {
  description = "Flag if kms encryption is enabled in all resources"
  type        = bool
  default     = false
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the resources are provisioned"
}

variable "terraform_provider_role" {
  type        = string
  description = "Role used by Terraform to provision resources"
}

variable "source_repo" {
  description = "Git repository which served as source stage for CodePipeline"
  type = list(object({
    id  = string
    connection_arn  = string
    branch = string
  }))
}

variable "codebuild_projects_config" {
  description = "Codebuild projects configuration"
  type = list(object({
    name  = string
    cache  = bool
    log_enabled = bool
  }))

  default = [
    { name = "scan", cache = false, log_enabled = false },
    { name = "plan", cache = false, log_enabled = false },
    { name = "apply", cache = false, log_enabled = false }
  ]
}

variable "codepipeline_stages_config" {
  description = "CodePipeline stages configuration"
  type = list(object({
    name  = string
    category  = string
    input_artifacts = string
    output_artifacts = string
  }))

  default = [
    { name = "plan", category = "Build", input_artifacts = "SourceOutput", output_artifacts = "PlanOutput" },
    { name = "approve", category = "Approval", input_artifacts = "", output_artifacts = "" },
    { name = "apply", category = "Build", input_artifacts = "PlanOutput", output_artifacts = "" }
  ]
}

variable "target_accounts" {
  description = "Accounts where CodePipeline will install resources to"
  type = list(object({
    environment  = string
    state_bucket = string
    state_lock_table = string
    workload_role = string
  }))

  default = [
    {
      environment      = "dev",
      state_bucket     = "obi-dev-terraform-state",
      state_lock_table = "arn:aws:dynamodb:eu-central-1:248189918720:table/obi-dev-terraform-state-lock",
      workload_role    = "arn:aws:iam::225989357007:role/LZ_CICD_Group_OBI_CrossAccount_role"
    },
    {
      environment      = "acc",
      state_bucket     = "obi-acc-terraform-state",
      state_lock_table = "arn:aws:dynamodb:eu-central-1:248189918720:table/obi-acc-terraform-state-lock",
      workload_role    = "arn:aws:iam::314146311773:role/LZ_CICD_Group_OBI_CrossAccount_role"
    },
    {
      environment      = "prod",
      state_bucket     = "obi-prod-terraform-state",
      state_lock_table = "arn:aws:dynamodb:eu-central-1:248189918720:table/obi-prod-terraform-state-lock",
      workload_role    = "arn:aws:iam::954976319120:role/LZ_CICD_Group_OBI_CrossAccount_role"
    }
  ]
}