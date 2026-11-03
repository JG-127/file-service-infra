output "state_bucket" {
  description = "원격 state 버킷 이름 — 다른 루트의 backend.tf 에 문자열로 적음"
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  value = aws_s3_bucket.state.arn
}
