# Préliminaires – Setup GCP & Terraform (socle plateforme)

## Objectif

Ce document décrit **l’ensemble des étapes préliminaires**, y compris le **setup du compte GCP**, nécessaires avant tout travail Terraform sur Google Cloud Platform (GCP).

L’objectif est de disposer d’un **socle plateforme propre, cohérent et reproductible**, aligné avec :
- un usage Terraform sérieux,
- des déploiements Kubernetes ultérieurs (GKE puis AKS par transposition),
- un projet RNCP structuré,
- des pratiques DevOps (type SFEIR).

Aucune ressource applicative n’est créée à ce stade.

---

## 0. Setup du compte GCP (pré-requis absolus)

### 0.1 Environnement local

- OS : Linux (poste local)
- IDE : VS Code
- Outils installés :
  - Terraform ≥ 1.6
  - Google Cloud SDK (`gcloud`, `gsutil`)

Le travail est réalisé **exclusivement en ligne de commande**, conformément aux pratiques DevOps.

---

### 0.2 Compte Google Cloud

- Compte Google Cloud actif
- **Free Trial activé** (crédits disponibles, aucun paiement automatique)
- Compte de facturation existant et opérationnel

Ce compte de facturation est utilisé pour **autoriser l’activation des APIs** et la création de ressources, sans engagement financier tant que les crédits ne sont pas dépassés.

---

### 0.3 IAM au niveau du compte / projet

Sur le projet d’étude :

- Rôle **Owner** accordé à l’utilisateur
  - nécessaire pour :
    - lier le billing,
    - activer les APIs,
    - gérer IAM,
    - travailler sereinement avec Terraform.

Ce niveau de droit est **acceptable dans un contexte d’apprentissage / projet personnel**.

---

## 1. Authentification GCP

### 1.1 Connexion au compte Google

```bash
gcloud auth login
```

Vérification :

```bash
gcloud auth list
```

---

## 2. Création et sélection du projet GCP

### 2.1 Règles de nommage GCP

- Le `project_id` :
  - est **immuable**,
  - doit contenir uniquement : lettres minuscules, chiffres, tirets (`-`),
  - **les underscores `_` sont interdits**.
- Le `--name` est un libellé humain, modifiable, sans impact technique.

---

### 2.2 Projet retenu

- **Project ID** : `terraform-gcp-sfeir`
- **Nom lisible** : `Terraform GCP SFEIR`

Création (ou restauration si déjà existant) :

```bash
gcloud projects create terraform-gcp-sfeir \
  --name="Terraform GCP SFEIR"
```

Sélection du projet actif :

```bash
gcloud config set project terraform-gcp-sfeir
```

Vérification :

```bash
gcloud config list
```

---

## 3. Alignement des Application Default Credentials (ADC)

### 3.1 Contexte

Terraform, les SDKs et les outils cloud utilisent les **Application Default Credentials (ADC)**.
Le projet de quota associé aux ADC doit correspondre au projet GCP actif.

---

### 3.2 Alignement du projet de quota

```bash
gcloud auth application-default set-quota-project terraform-gcp-sfeir
```

Vérification optionnelle :

```bash
gcloud auth application-default show-quota-project
```

---

## 4. Facturation (Billing)

### 4.1 Lier le projet au compte de facturation

Le projet doit être rattaché à un compte de facturation pour permettre :
- l’activation des APIs payantes (Compute, GKE),
- la création de ressources Terraform.

Méthode CLI (robuste et reproductible) :

```bash
gcloud billing accounts list
```

Puis :

```bash
gcloud billing projects link terraform-gcp-sfeir \
  --billing-account <BILLING_ACCOUNT_ID>
```

Vérification :

```bash
gcloud billing projects describe terraform-gcp-sfeir
```

---

## 5. Activation des APIs GCP minimales

Les APIs sont **activées par projet**, pas par compte.

APIs nécessaires pour un socle Terraform / Kubernetes :

```bash
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  storage.googleapis.com
```

---

## 6. État final du setup GCP

À l’issue de ces étapes, l’état attendu est :

- environnement Linux local opérationnel,
- Terraform et gcloud installés,
- projet GCP `terraform-gcp-sfeir` configuré,
- billing activé (Free Trial),
- rôle IAM Owner,
- APIs nécessaires activées,
- authentification ADC configurée avec :
  - projet actif,
  - quota project aligné.

Ce socle constitue la **base plateforme** sur laquelle Terraform peut être utilisé sans friction.

---

## 7. Étape suivante

Démarrage du projet Terraform :

- initialisation Terraform minimale,
- ajout du provider Google,
- validation de la chaîne Terraform → GCP,
- montée en complexité progressive (variables, réseau, IAM, puis Kubernetes).

Ces étapes sont documentées séparément.
