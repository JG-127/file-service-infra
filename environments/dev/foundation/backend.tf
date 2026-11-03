terraform {
  backend "s3" {
    bucket       = "ljg14-tfstate-20261102"
    key          = "dev/foundation/terraform.tfstate"
    region       = "ap-northeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
