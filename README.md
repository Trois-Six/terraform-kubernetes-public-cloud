# 1st: Deploy

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

# 2nd: Get kubeconfig credential after deployment

```bash
$ gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region) --project $(terraform output -raw project_id)
```

