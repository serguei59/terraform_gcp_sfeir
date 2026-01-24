# Préliminaires – Mise en place GCP pour Terraform

## Objectif

Ce document décrit **les étapes préliminaires nécessaires** avant tout travail Terraform sur Google Cloud Platform (GCP).

Ces étapes visent à :
- disposer d’un environnement GCP **propre et maîtrisé**,
- éviter les erreurs classiques (billing, quotas, APIs),
- préparer un socle **réutilisable** pour des projets Terraform plus avancés  
  (GKE, AKS par transposition, projet RNCP, etc.).

Aucune ressource applicative n’est créée à ce stade.

---

## 1. Environnement local

### 1.1 Outils utilisés

- VS Code (IDE principal)
- Terminal intégré VS Code
- Terraform ≥ 1.6
- Google Cloud SDK (`gcloud`, `gsutil`)

Tout le travail est réalisé **en ligne de commande**, conformément aux pratiques DevOps.

---

## 2. Authentification GCP

### 2.1 Connexion au compte Google

```bash
gcloud auth login
```

Vérification :

```bash
gcloud auth list
```

---

## 3. Création et sélection du projet GCP

### 3.1 Règles de nommage GCP

- Le `project_id` :
  - est **immuable**,
  - doit contenir uniquement : lettres minuscules, chiffres, tirets (`-`),
  - **les underscores `_` sont interdits**.
- Le `--name` est un libellé humain, modifiable, sans impact technique.

### 3.2 Projet retenu

- **Project ID** : `terraform-gcp-sfeir`
- **Nom lisible** : `Terraform GCP SFEIR`

```bash
gcloud projects create terraform-gcp-sfeir \
  --name="Terraform GCP SFEIR"
```

```bash
gcloud config set project terraform-gcp-sfeir
gcloud config list
```

---

## 4. Alignement des Application Default Credentials (ADC)

```bash
gcloud auth application-default set-quota-project terraform-gcp-sfeir
```

---

## 5. Facturation (Free Trial)

```bash
gcloud billing accounts list
gcloud billing projects link terraform-gcp-sfeir \
  --billing-account <BILLING_ACCOUNT_ID>
```

---

## 6. Activation des APIs GCP minimales

```bash
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  cloudresourcemanager.googleapis.com \
  storage.googleapis.com
```

---

## 7. État final attendu

- projet GCP opérationnel
- billing lié (Free Trial)
- APIs activées
- environnement prêt pour Terraform

---

## 8. Étape suivante

Initialisation Terraform et ajout du provider Google.
