data "aws_caller_identity" "current" {}

data "aws_ecr_repository" "app" {
  name = "${var.student_id}-file-service"
}

data "aws_dynamodb_table" "app" {
  name = var.app_table_name
}

locals {
  files_bucket_name = "${var.student_id}-${var.environment}-files-${var.bucket_date}"
  events_table_name = "${var.student_id}-${var.environment}-file-events"

  # 콘솔 표의 키 속성(파티션 · 정렬)만 골라 냄 — 이름 · 타입
  app_hash_attr = [
    for a in data.aws_dynamodb_table.app.attribute : a
    if a.name == data.aws_dynamodb_table.app.hash_key
  ][0]
  app_range_attr = [
    for a in data.aws_dynamodb_table.app.attribute : a
    if a.name == data.aws_dynamodb_table.app.range_key
  ][0]
}

resource "aws_s3_bucket" "files" {
  bucket        = local.files_bucket_name
  force_destroy = true

  tags = {
    Name = local.files_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "files" {
  bucket = aws_s3_bucket.files.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "files" {
  bucket = aws_s3_bucket.files.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "files" {
  bucket                  = aws_s3_bucket.files.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "files" {
  bucket = aws_s3_bucket.files.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.files]
}

resource "aws_dynamodb_table" "events" {
  name         = local.events_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.app_hash_attr.name
  range_key    = local.app_range_attr.name

  attribute {
    name = local.app_hash_attr.name
    type = local.app_hash_attr.type
  }

  attribute {
    name = local.app_range_attr.name
    type = local.app_range_attr.type
  }

  attribute {
    name = "type"
    type = "S"
  }

  global_secondary_index {
    name            = "type-at-index"
    hash_key        = "type"
    range_key       = local.app_range_attr.name
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "expireAt"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = local.events_table_name
  }
}
