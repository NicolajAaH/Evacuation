terraform {
    required_providers {
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = ">= 2.0.0"
        }
    }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "sdu_evac" {
  metadata {
    name = "sdu-evac"
  }
}

resource "kubernetes_deployment" "sdu_evac_backend" {
  metadata {
    name = "sdu-evac-backend"

    labels = {
      app = "sdu-evac-backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "sdu-evac-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "sdu-evac-backend"
        }
      }

      spec {
        container {
          name  = "sdu-evac-backend"
          image = "localhost:5001/sdu-evac-backend:v1.0.0"

          env {
            name  = "PORT"
            value = "80"
          }

          env {
            name  = "MONGO_DB_CONNECTION_STRING"
            value = "mongodb://mongodb:27017"
          }

          env {
            name  = "MONGO_DB_NAME"
            value = "sdu-evac"
          }

          env {
            name  = "REDIS_URI"
            value = "redis://redis-master"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "sdu_evac_backend" {
  metadata {
    name = "sdu-evac-backend"

    labels = {
      app = "sdu-evac-backend"
    }
  }

  spec {
    port {
      name        = "80-80"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "sdu-evac-backend"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "sdu_evac_frontend" {
  metadata {
    name = "sdu-evac-frontend"

    labels = {
      app = "sdu-evac-frontend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "sdu-evac-frontend"
      }
    }

    template {
      metadata {
        labels = {
          app = "sdu-evac-frontend"
        }
      }

      spec {
        container {
          name  = "sdu-evac-frontend"
          image = "localhost:5001/sdu-evac-frontend:v0.1.0"
        }
      }
    }
  }
}

resource "kubernetes_service" "sdu_evac_frontend" {
  metadata {
    name = "sdu-evac-frontend"

    labels = {
      app = "sdu-evac-frontend"
    }
  }

  spec {
    port {
      name        = "80-80"
      protocol    = "TCP"
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "sdu-evac-frontend"
    }

    type = "ClusterIP"
  }
}