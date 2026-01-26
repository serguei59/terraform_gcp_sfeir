# 02 – Variables et locals (COMPRENDRE par la pratique)

> Objectif de ce chapitre : **ne plus confondre variables et locals**  
> et être capable d’expliquer *pourquoi* et *quand* utiliser l’un ou l’autre.

---

## 1. Intuition de départ

Règle mentale simple :

- **Variable** → vient de l’extérieur (environnement, contexte)
- **Local** → règle interne, calcul, convention projet

---

## 2. Variables : les entrées du système

### `variables.tf`

```hcl
variable "project_id" {
  description = "ID du projet GCP cible"
  type        = string
}

variable "region" {
  description = "Région GCP principale"
  type        = string
  default     = "europe-west1"
}

variable "environment" {
  description = "Nom de l'environnement (dev, test, prod)"
  type        = string
}
```

### `terraform.tfvars`

```hcl
project_id  = "terraform-gcp-sfeir"
environment = "dev"
```

---

## 3. Locals : les règles internes du projet

### `locals.tf`

```hcl
locals {
  project_prefix = "sfeir-terraform"

  env = var.environment

  resource_name_prefix = "${local.project_prefix}-${local.env}"

  common_labels = {
    project     = "terraform-gcp-sfeir"
    environment = local.env
    managed_by  = "terraform"
  }
}
```

---

## 4. Comparaison essentielle

❌ Mauvais usage :

```hcl
variable "resource_name_prefix" {
  default = "sfeir-terraform-dev"
}
```

✅ Bon usage :

```hcl
locals {
  resource_name_prefix = "sfeir-terraform-${var.environment}"
}
```

---

## 5. Utilisation dans le provider

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

---

## 6. Exercice mental

| Élément | Type | Justification |
|------|------|---------------|
| project_id | variable | vient de l’extérieur |
| region | variable | dépend du contexte |
| environment | variable | choix utilisateur |
| resource_name_prefix | local | règle interne |
| common_labels | local | convention |

---

## 7. Validation

```bash
terraform init
terraform validate
terraform plan
```

---

## 8. Phrase clé à retenir

> *Les variables sont les entrées du système Terraform.  
> Les locals sont les règles internes appliquées à ces entrées.*

---

## 9. Étape suivante

Backend distant Terraform (GCS), une fois ces notions assimilées.
