# ------------------------
# cloudwatch log groupの設定
# ------------------------
resource "aws_cloudwatch_log_group" "batch_log_group" {
  name              = "${var.project}-${var.environment}-batch-log-group"
  retention_in_days = 14
}
