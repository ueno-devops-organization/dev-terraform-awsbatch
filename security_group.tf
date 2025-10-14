# ------------------------
# security groupの設定
# ------------------------
resource "aws_security_group" "vpc_batch_sg" {
  name        = "${var.project}-${var.environment}-sg-vpc-batch"
  description = "Security group for VPC batch"
  vpc_id      = aws_vpc.vpc_batch.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
