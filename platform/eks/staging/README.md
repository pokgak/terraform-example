# README

The kubernetes provider relies on the EKS cluster being created first. When first time applying this module, use targeted apply and create only the EKS cluster and all its dependency like the following:

```
terraform apply -auto-approve -target=module.eks.aws_eks_cluster.this[0]
```

After that command fiished without error, then run the full apply:

```
terraform apply -auto-approve
```