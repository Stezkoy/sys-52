#For terraform >=1.6<=1.8.5
terraform {
  required_version = ">=1.8.4"


  required_providers {

    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}