
resource "aws_codepipeline" "terraform_pipeline" {

  name          = "${var.project_name}-pipeline"
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

  #  trigger {
  #    provider_type = "CodeStarSourceConnection"
  #    git_configuration {
  #      source_action_name = "TriggerAction"
  #      push {
  #        branches {
  #          includes = ["main"]
  #        }
  #      }
  #      #      pull_request {
  #      #        events = ["CLOSED"]
  #      #        branches {
  #      #          includes = ["main", "foobar"]
  #      #          excludes = ["feature/*", "issue/*"]
  #      #        }
  #      #      }
  #    }
  #  }

  dynamic "stage" {
    for_each = var.target_accounts

    content {
      name = "Deployment-${stage.value["environment"]}"

      dynamic "action" {
        for_each = var.stages

        content {
          category         = action.value["category"]
          name             = "Action-${action.value["name"]}"
          owner            = "AWS"
          provider         = "CodeBuild"
          input_artifacts  = (action.value["input_artifacts"] == "SourceOutput") ? ["SourceOutput"] : ["test-${stage.value["environment"]}_${action.value["input_artifacts"]}"]
          output_artifacts = ["test-${stage.value["environment"]}_${action.value["output_artifacts"]}"]
          version          = "1"
          run_order        = index(var.stages, action.value) + 2

          configuration = {
            ProjectName = "${var.project_name}-${action.value["name"]}"
            EnvironmentVariables = jsonencode([
              {
                name  = "WORKLOAD_ROLE_ARN"
                value = "${stage.value["workload_role"]}"
                type  = "PLAINTEXT"
              },
            ])
          }
        }
      }
    }

  }



}