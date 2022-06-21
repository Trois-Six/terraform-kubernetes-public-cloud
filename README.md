# 1st: Setup

```bash
$ cp terraform.tfvars.template terraform.tfvars
$ ## Set variables
```
# 2nd: Deploy

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
# 3rd: Get kubeconfig credential after deployment

```bash
$ gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region) --project $(terraform output -raw project_id)
```

# 4th: Play!

```bash
$ kubectl get nodes
$ ...
```