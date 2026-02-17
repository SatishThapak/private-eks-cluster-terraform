resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-eks"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-node-group"
  node_role_arn   = var.worker_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = [var.instance_type]
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
