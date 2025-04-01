terraform {
  backend "s3" {
    bucket = "mystatebackendbucket"
    key = "state_file"
    region = "eu-central-1"
    encrypt = true
    use_lockfile = true
  }
}