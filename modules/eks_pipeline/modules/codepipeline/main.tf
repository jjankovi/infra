
resource "aws_codepipeline" "terraform_pipeline" {

  name          = "${var.project_name}"
  pipeline_type = "V2"
  role_arn      = var.codepipeline_role_arn
  tags          = var.tags

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"

    dynamic encryption_key {
      for_each = var.kms_enabled == true ? toset([1]) : toset([])

      content {
        id   = var.kms_key_arn
        type = "KMS"
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Download-Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeStarSourceConnection"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.source_repo_id
        BranchName       = var.source_repo_branch
      }
    }
  }

#  stage {
#    name = "Scan"
#
#    action {
#      category         = "Build"
#      owner            = "AWS"
#      provider         = "CodeBuild"
#      version          = "1"
#      name             = "Terraform-Scan"
#      input_artifacts  = ["SourceOutput"]
#      output_artifacts = []
#      run_order        = 2
#
#      configuration = {
#        ProjectName = "${var.project_name}-scan"
#      }
#    }
#  }

  stage {
    name = "Build"

    action {
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      name             = "App-Build"
      input_artifacts  = ["SourceOutput"]
      output_artifacts = []
      run_order        = 2

      configuration = {
        ProjectName = "${var.project_name}-build"
        EnvironmentVariables = jsonencode([
          {
            name  = "ECR_REPO_URL"
            value = var.ecr_repo
            type  = "PLAINTEXT"
          },
          {
            name  = "AWS_DEFAULT_REGION"
            value = data.aws_region.current.name
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

#  dynamic "stage" {
#    for_each = var.target_accounts
#
#    content {
#      name = "Deployment-${stage.value["environment"]}"
#
#      dynamic "action" {
#        for_each = var.stages
#
#        content {
#          category         = action.value["category"]
#          name             = "Action-${action.value["name"]}"
#          owner            = "AWS"
#          provider         = action.value["category"] == "Build" ? "CodeBuild" : "Manual"
#          input_artifacts  = action.value["input_artifacts"] == "" ? [] : (action.value["input_artifacts"] == "SourceOutput" ? ["SourceOutput"] : ["SourceOutput", "${stage.value["environment"]}_${action.value["input_artifacts"]}"])
#          output_artifacts = action.value["output_artifacts"] == "" ? [] : ["${stage.value["environment"]}_${action.value["output_artifacts"]}"]
#          version          = "1"
#          run_order        = index(var.stages, action.value) + 2
#
#          configuration = {
#            CustomData = action.value["category"] == "Approval" ? "Please verify the terraform plan output" : null
#
#            ProjectName = action.value["category"] == "Build" ? "${var.project_name}-${action.value["name"]}" : null
#            PrimarySource = action.value["category"] == "Build" ? "SourceOutput" : null
#            EnvironmentVariables = action.value["category"] == "Approval" ? null : jsonencode([
#              {
#                name  = "ENVIRONMENT"
#                value = "${stage.value["environment"]}"
#                type  = "PLAINTEXT"
#              },
#              {
#                name  = "WORKLOAD_ROLE_ARN"
#                value = "${stage.value["workload_role"]}"
#                type  = "PLAINTEXT"
#              },
#              {
#                name  = "TF_STATE_BUCKET"
#                value = "${stage.value["state_bucket"]}"
#                type  = "PLAINTEXT"
#              },
#              {
#                name  = "TF_STATE_KEY"
#                value = "${var.project_name}.${stage.value["environment"]}.terraform.tfstate"
#                type  = "PLAINTEXT"
#              },
#              {
#                name  = "TF_DYNAMODB_TABLE"
#                value = "${stage.value["state_lock_table"]}"
#                type  = "PLAINTEXT"
#              },
#            ])
#          }
#        }
#      }
#    }
#
#  }

}