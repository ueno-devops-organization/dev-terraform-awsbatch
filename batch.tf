# ------------------------
# コンピュート環境の作成
# ------------------------
resource "aws_batch_compute_environment" "batch_fargate_environment" {
  compute_environment_name = "${var.project}-${var.environment}-batch-fargate-environment"
  type                     = "MANAGED"
  compute_resources {
    type               = "FARGATE"
    min_vcpus          = 0
    max_vcpus          = 1
    subnets            = [aws_subnet.public_subnet_1a.id]
    security_group_ids = [aws_security_group.vpc_batch_sg.id]
  }

  service_role = aws_iam_role.batch_service.arn
}

# ------------------------
# ジョブキューの作成
# ------------------------
resource "aws_batch_job_queue" "batch_job_queue" {
  name                 = "${var.project}-${var.environment}-batch-job-queue"
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.batch_fargate_environment.arn]
}

# ------------------------
# ジョブ定義の作成
# ------------------------
resource "aws_batch_job_definition" "batch_job_definition" {
  name                  = "${var.project}-${var.environment}-batch-job-definition"
  type                  = "container"
  platform_capabilities = ["FARGATE"]
  container_properties = jsonencode({
    image      = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/my-amazonlinux-repo:latest"
    command    = ["sh", "-c", "echo Hello World! $(TZ='Asia/Tokyo' date '+%Y-%m-%d %H:%M:%S')"]
    jobRoleArn = aws_iam_role.batch_job.arn
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "1"
      },
      {
        type  = "MEMORY"
        value = "2048"
      }
    ]
    executionRoleArn = aws_iam_role.ecs_task_execution_role.arn
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "${var.project}-${var.environment}-batch-log-group",
        "awslogs-region"        = var.region,
        "awslogs-stream-prefix" = "batch-job"
      }
    }

    networkConfiguration = {
      assignPublicIp = "ENABLED"
    }
  })
}
