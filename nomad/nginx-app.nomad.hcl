variable "image_tag" {
  type        = string
  description = "GHCR image tag (full commit SHA) to deploy"
}

job "nginx-app" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "10s"
    healthy_deadline = "2m"
    auto_revert      = true
  }

  group "web" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "15s"
      mode     = "fail"
    }

    reschedule {
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "5m"
      unlimited      = true
    }

    service {
      name     = "nginx-app"
      port     = "http"
      provider = "consul"

      check {
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "ghcr.io/odiliemmanuel/devops-intern-final:${var.image_tag}"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
