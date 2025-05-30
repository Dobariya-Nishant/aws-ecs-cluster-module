resource "aws_ecs_cluster_capacity_providers" "combine" {
  count = var.provider_type == "combine" ? 1 : 0

  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = concat(
    ["FARGATE", "FARGATE_SPOT"],
    aws_ecs_capacity_provider.ec2[*].name
  )

  dynamic "default_capacity_provider_strategy" {
    for_each = aws_ecs_capacity_provider.ec2

    content {
      capacity_provider = default_capacity_provider_strategy.value["name"]
      weight            = 2
      base              = 0
    }
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 0
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 0
    base              = 0
  }
}

resource "aws_ecs_cluster_capacity_providers" "ec2" {
  count = var.provider_type == "ec2" ? 1 : 0

  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = aws_ecs_capacity_provider.ec2[*].name

  dynamic "default_capacity_provider_strategy" {
    for_each = aws_ecs_capacity_provider.ec2

    content {
      capacity_provider = default_capacity_provider_strategy.value["name"]
      weight            = 1
      base              = 1
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate-spot" {
  count = var.provider_type == "fargate-spot" ? 1 : 0

  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
    base              = 1
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 0
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  count = var.provider_type == "fargate" ? 1 : 0

  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}