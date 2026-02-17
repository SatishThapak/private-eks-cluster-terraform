resource "aws_iam_role" "eks_master" {
  name = "${var.project_name}-${var.environment}-eks-master"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })  

}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  role       = aws_iam_role.eks_master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "eks_worker" {
  name = "${var.project_name}-${var.environment}-eks-worker"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  role       = aws_iam_role.eks_worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "eks_worker_profile" {
  name = "${var.project_name}-${var.environment}-eks-worker-profile"
  role = aws_iam_role.eks_worker.name

}

resource "aws_iam_policy" "cluster_autoscaler" {
  name = "${var.project_name}-${var.environment}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeTags",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        Resource = "*"
      }
    ]
  })

}


resource "aws_iam_role" "jump_host" {
  name = "${var.project_name}-${var.environment}-jump-host"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
  Project     = var.project_name
  Environment = var.environment
  Role        = "JumpHost"
}

}

resource "aws_iam_role_policy_attachment" "jump_host_admin_access" {
  role       = aws_iam_role.jump_host.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jump_host_profile" {
  name = "${var.project_name}-${var.environment}-jump-host-profile"
  role = aws_iam_role.jump_host.name
}
