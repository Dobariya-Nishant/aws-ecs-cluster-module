output "name" {
  value = local.ecs_cluster_name
}

output "id" {
  value = aws_ecs_cluster.cluster.id
}

output "arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "services" {
  value = length(aws_ecs_service.service) ? aws_ecs_service.service : []
}