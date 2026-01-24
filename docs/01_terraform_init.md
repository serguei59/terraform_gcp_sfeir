# 01 – Initialisation Terraform (premier lien avec GCP)

## Objectif

Ce document décrit la **première étape Terraform proprement dite**, après le setup complet du compte GCP.

L’objectif est volontairement **minimaliste** :
- vérifier que Terraform fonctionne correctement,
- établir un **premier lien contrôlé** avec GCP,
- valider la chaîne : **Terraform → Provider → GCP**,
- sans créer de ressources cloud.

Cette étape constitue le **socle technique** de tout le reste du projet.

---

## 1. Principe de la démarche

À ce stade :
- le projet GCP est prêt,
- le billing est activé,
- les APIs sont actives,
- l’authentification ADC est alignée.

👉 Terraform peut maintenant être introduit **sans ambiguïté**.

On commence **simple**, sans backend distant, sans modules, sans ressources.

---

## 2. Structure initiale du projet Terraform

À la racine du dépôt :

```bash
mkdir terraform
cd terraform
```

Arborescence cible à ce stade :

```
terraform/
├── main.tf
└── provider.tf
```

---

## 3. Initialisation Terraform minimale

### 3.1 Fichier `main.tf`

```hcl
terraform {
  required_version = ">= 1.6.0"
}
```

Ce fichier :
- vérifie la version de Terraform,
- ne déclare encore aucun provider,
- ne crée aucune ressource.

---

### 3.2 Initialisation et validation

```bash
terraform init
terraform validate
```

Résultat attendu :
- initialisation réussie,
- aucune erreur,
- aucun accès à GCP à ce stade.

---

## 4. Déclaration du provider Google Cloud

### 4.1 Fichier `provider.tf`

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "terraform-gcp-sfeir"
  region  = "europe-west1"
}
```

Cette déclaration :
- fixe explicitement le provider utilisé,
- évite toute ambiguïté de version,
- relie Terraform au projet GCP cible.

---

## 5. Validation de la chaîne Terraform → GCP

### 5.1 Réinitialisation

```bash
terraform init
```

### 5.2 Planification

```bash
terraform plan
```

Résultat attendu :
- aucun changement proposé,
- aucune ressource à créer,
- aucune erreur d’authentification ou d’API.

👉 Cela confirme que :
- Terraform est opérationnel,
- le provider Google est correctement configuré,
- l’accès au projet GCP est fonctionnel.

---

## 6. Ce que cette étape permet réellement

D’un point de vue plateforme, cette étape permet de :

- valider l’environnement local,
- figer les versions Terraform / provider,
- vérifier la configuration du projet GCP,
- éviter les erreurs plus tard, lorsqu’il y aura :
  - réseau,
  - IAM,
  - stockage,
  - Kubernetes.

C’est l’équivalent d’un **"hello world" d’infrastructure"**.

---

## 7. Règles à ce stade

À ce point précis du projet :

- ❌ pas de ressources cloud
- ❌ pas de VM
- ❌ pas de réseau
- ❌ pas de backend distant
- ✔ validation de la mécanique uniquement

---

## 8. Étape suivante

La prochaine étape consistera à :
- introduire les **variables et locals**,
- sortir les valeurs codées en dur,
- préparer la structuration du projet Terraform.

Cette étape fera l’objet du document :
**`02_variables_locals.md`**.
