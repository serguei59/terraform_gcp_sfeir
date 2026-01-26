# 02 – Variables et locals (structuration Terraform)

## Objectif

Cette étape vise à rendre la configuration Terraform maintenable et réutilisable,
en supprimant les valeurs codées en dur.

---

## 1. Variables

### `variables.tf`

```hcl
variable "project_id" {
  description = "ID du projet GCP"
  type        = string
}

variable "region" {
  description = "Région GCP"
  type        = string
  default     = "europe-west1"
}
```

---

### `terraform.tfvars`

```hcl
project_id = "terraform-gcp-sfeir"
```

---

## 2. Provider mis à jour

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

---

## 3. Locals

### `locals.tf`

```hcl
locals {
  environment = "dev"
  project_tag = "terraform-gcp-sfeir"
}
```

---

## 4. Validation

```bash
terraform init
terraform validate
terraform plan
```

---

## 5. Étape suivante

Création du backend distant Terraform (GCS).
