output "files_bucket" {
  description = "앱 파일 버킷 이름 — ConfigMap APP_S3_BUCKET"
  value       = aws_s3_bucket.files.id
}

output "files_bucket_arn" {
  value = aws_s3_bucket.files.arn
}

output "events_table" {
  description = "이벤트 표 이름 — ConfigMap APP_EVENTS_TABLE"
  value       = aws_dynamodb_table.events.name
}

output "events_table_arn" {
  value = aws_dynamodb_table.events.arn
}

output "ecr_repository_url" {
  description = "이미지 주소 앞부분 — overlays/eks 의 image"
  value       = data.aws_ecr_repository.app.repository_url
}
