variable "student_id" {
  type = string

  validation {
    condition     = can(regex("^[a-z]{3}[0-9]{2}$", var.student_id))
    error_message = "student_id 는 소문자 3자 + 숫자 2자리 (예: kdh01 · cld00)."
  }
}

variable "team_number" {
  type        = string
  description = "PROJECT 1 팀 번호 — 태그 값이므로 문자열"
}

variable "environment" {
  type    = string
  default = "shared"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "bucket_date" {
  type    = string
  default = "20261102"
}

variable "admin_users" {
  type    = list(string)
  default = ["inst01", "fac01"]
}
