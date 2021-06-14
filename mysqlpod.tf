locals {
  labels = merge(var.labels, {
    app = "mysql"
    deploymentName = var.name
  })

  selectors = merge(var.selectors, {
    app = "mysql"
    deploymentName = var.name
  })
}

resource "kubernetes_namespace" "mysql-namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "sqlsecret" {
  metadata {
    name = "sqlsecret"
    namespace= var.namespace
  }

  data = {
	rootpassword= var.adminpassword
  }
  type="Opaque"


}



resource "kubernetes_persistent_volume_claim" "mysql-pvc-student1" {
  metadata {
    name = var.pvc
    namespace = var.namespace
  }
  spec {
    storage_class_name = var.mysql_storage_class
    access_modes = [
      "ReadWriteOnce"
    ]
    resources {
      requests = {
        storage = var.mysql_pvc_size
      }
    }
  }
}



resource "kubernetes_deployment" "mysql-deployment-student1" {
  metadata {
    name = var.name
    namespace = var.namespace
    labels = local.labels
  }

  spec {
    replicas = 1
    selector {
      match_labels = local.selectors
    }

    template {
      metadata {
        name = "mysql"
        labels = local.labels
      }

      spec {
        volume {
          name = "mysqldb"
          persistent_volume_claim {
            claim_name = var.pvc
          }
        }
	termination_grace_period_seconds=10


        container {
          name = "mysql"
          image = "${var.mysql_image_url}:${var.mysql_image_tag}"

          port {
            container_port = 3306
          }

          volume_mount {
            mount_path = "/var/lib/mysql"
            name = "mysqldb"
          }

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
		          secret_key_ref {
		            name= "sqlsecret"
		            key= "rootpassword"
		      }

	    }
          }

        }
      }
    }
  }
}


resource "kubernetes_service" "mysql-deployment-student1" {
  metadata {
    name = "${var.name}-service"
    namespace = var.namespace
  }

  spec {
    port {
      port = 3306
      target_port = 3306
    }

    selector = local.selectors

    type="LoadBalancer"
  }
}
