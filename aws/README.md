# 1st: Setup

```bash
$ cp terraform.tfvars.template terraform.tfvars
$ ## Set variables in terraform.tfvars
```
# 2nd: Deploy

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
# 3rd: Get kubeconfig credential after deployment

```bash
$ aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw kubernetes_cluster_name)
```

# 4th: Play!

```bash
$ kubectl get nodes
$ ...
```