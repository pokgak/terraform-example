# README

Resources in this repository is meant to be used with ACloudGuru (ACG) AWS cloud playground. You'll see the default user `cloud_user` that is created when ACG created the sandbox account.

## AWS Credentials

Update the AWS variable set on Terraform cloud with the one given by ACG after starting the cloud playground.

## Generate kubeconfig

Pull kubeconfig for EKS and save to local file `.kubeconfig`:

```
aws eks update-kubeconfig --kubeconfig .kubeconfig --name staging-eks --alias staging-eks
```

Make sure to set `KUBECONFIG=.kubeconfig` in your env (using direnv)