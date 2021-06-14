Deploy MySQL instance on Amazon EKS cluster

The purpose of this tutorial is a walk-through of the steps involved in deploying and managing a highly available MySQL database on Amazon EKS.

## Prerequisites

Before you get started, you’ll need to have these things:
* Terraform > 0.13.x
* kubectl installed on the compute that hosts terraform
* An AWS account with the IAM permissions
* AWS CLI : [the AWS CLI Documentation](https://github.com/aws/aws-cli/tree/v2)
* AWS IAM Authenticator : [the AWS IAM Authenticator Documentation](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
* EKS cluster running
* A default storage class
* MySQL client


## Initial setup

For the creation of the EKS cluster, see the previous post:[Create Amazon EKS cluster using Terraform](https://techlabnews.com/2021/terraform-EKS-AWS/)

Clone the repository and install the dependencies:

```

$ git clone https://github.com/colussim/terraform-mysql-eks-aws.git
$ cd terraform-mysql-eks-aws.git
$ terraform init

```


## Usage

Create a MS SQL Server instance:

```
$ terraform apply \
 -var="name=mysql-deployment-student1" \
 -var="namespace=student1" \
 -var="pvc=pvc-sql-data01" \
 -var="mysql_pvc_size=50Gi" \
 -var="mysql_storage_class=gp2" \
 -var="mysql_image_url=mysql" \
 -var="mysql_image_tag=8.0.25" \
 -var="adminpassword=Bench123"
```

If you use the ***terraform apply*** command without parameters the default values will be those defined in the ***variables.tf*** file.

This will do the following :
* create a namespace
* create of the ***secret*** object for the password sa for the MS SQL Server instance  
  * the password is base64 encoded, in this example the password is : Bench123
* create a PVC : Persistant Volume Claim
* create a deployment object for MySQL Server : create a MySQL Server instance
* create a service object for MySQL Server instance:

Tear down the whole Terraform plan with :

```
$ terraform destroy -force
```

Resources can be destroyed using the terraform destroy command, which is similar to terraform apply but it behaves as if all of the resources have been removed from the configuration.

Next step , see details [here](https://techlabnews.com/2021/terraform-mysql-EKS-AWS/index.html "Create Amazon EKS cluster using Terraform")
