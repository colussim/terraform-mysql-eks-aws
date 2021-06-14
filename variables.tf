variable "name" {
  default     = "mysql-deployment-student1"
  description = "The name of the MySQL deployment"
}
variable "namespace" {
  default     = "student1"
  description = "The kubernetes namespace to run the mysql server in."
}

variable "selectors" {
  type = map(string)
  default = {}
}

variable "labels" {
  type = map(string)
  default = {}
}

variable "pvc" {
  default     = "pvc-sql-data01"
  description = "The name of the PVC."
}

variable "mysql_pvc_size" {
  default     = "50Gi"
  description = "The storage size of the PVC"
}

variable "mysql_storage_class" {
  description = "The k8s storage class for the PVC used."
  default = "gp2"
}

variable "mysql_image_url" {
  default = "mysql"
  description = "The image url of the mysql version wanted"
}

variable "mysql_image_tag" {
  default = "8.0.25"
  description = "The image tag of the mysql version wanted"
}

variable "adminpassword" {
  default     = "Bench123"
  description = "Root Password"
}
