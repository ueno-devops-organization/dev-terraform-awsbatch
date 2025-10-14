# ------------------------
# AWS Batchサービスロールの作成
# AWS BatchがAWSリソースにアクセスするための権限を定義
# ------------------------
resource "aws_iam_role" "batch_service" {
  name               = "${var.project}-${var.environment}-batch-service-role"
  assume_role_policy = data.aws_iam_policy_document.batch_service_assume.json
}

data "aws_iam_policy_document" "batch_service_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "batch_service_policy_attachment" {
  role       = aws_iam_role.batch_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

# ------------------------
# ECSタスクがAWSリソースにアクセスするための権限を定義
# ------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project}-${var.environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_assume.json
}

data "aws_iam_policy_document" "ecs_task_execution_role_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ------------------------
# BatchジョブがAWSリソースにアクセスするための権限を定義
# ------------------------
resource "aws_iam_role" "batch_job" {
  name               = "${var.project}-${var.environment}-batch-job-role"
  assume_role_policy = data.aws_iam_policy_document.batch_job_assume.json
}

data "aws_iam_policy_document" "batch_job_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy" "batch_job" {
  role   = aws_iam_role.batch_job.id
  name   = "${var.project}-${var.environment}-batch-job-policy"
  policy = data.aws_iam_policy_document.batch_job_custom.json
}

data "aws_iam_policy_document" "batch_job_custom" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "*",
    ]
  }
}
