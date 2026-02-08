# 03_iap_firewall_zero_trust.md

## Objectif
Documenter et valider un **accès SSH Zero Trust** à une VM GCP :
- **sans IP publique**
- **sans règle firewall implicite**
- **uniquement via Google IAP**
- **contrôlé par IAM**

Ce document correspond à la clôture propre du **Module 3a – First Infrastructure Deployment** (repo SFEIR Terraform GCP).

---

## Contexte initial (important)
Par défaut, le réseau `default` de GCP contient une règle implicite :

- `default-allow-ssh`
- INGRESS
- TCP:22
- `0.0.0.0/0`

👉 Cette règle permet le SSH même **sans firewall explicite**.  
👉 Elle doit être supprimée pour démontrer un vrai modèle Zero Trust.

---

## Étape 1 — Suppression de la règle implicite

```bash
gcloud compute firewall-rules list   --filter="name=default-allow-ssh"

gcloud compute firewall-rules delete default-allow-ssh
```

Résultat attendu :
- plus aucune règle générique autorisant SSH
- réseau réellement restrictif

---

## Étape 2 — Firewall dédié IAP (Terraform)

```hcl
resource "google_compute_firewall" "allow_iap_ssh" {
  name        = "allow-iap-tcp-all-slb"
  network     = "default"
  direction   = "INGRESS"
  description = "Allow SSH only via Google IAP"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
```

Application :

```bash
terraform plan
terraform apply
```

---

## Étape 3 — Test d’accès SSH via IAP (succès attendu)

```bash
gcloud compute ssh slbinstance   --zone=europe-west1-c   --tunnel-through-iap
```

Résultat :
- connexion SSH réussie
- tunnel TCP ouvert via IAP
- authentification utilisateur gérée par IAM

---

## Étape 4 — Test SSH sans option explicite IAP

```bash
gcloud compute ssh slbinstance --zone=europe-west1-c
```

Message observé :
```
External IP address was not found; defaulting to using IAP tunneling.
```

👉 Interprétation :
- aucune IP publique disponible
- `gcloud` utilise automatiquement IAP
- **il n’existe plus aucun autre chemin réseau**

---

## Modèle de sécurité validé

```
Utilisateur
   ↓ (auth Google)
IAM
   ↓
IAP (proxy / bastion)
   ↓ (IP Google IAP)
Firewall (source_ranges)
   ↓
VM (SSH)
```

- Le firewall **ne connaît pas l’utilisateur**
- IAM décide **qui a le droit**
- IAP est **le seul point d’entrée**
- La VM n’est **jamais exposée à Internet**

---

## Points clés à retenir (certif / pro)

- `source_ranges` limite l’origine réseau (IAP uniquement)
- IAM restreint l’accès utilisateur
- La suppression des règles implicites est essentielle
- `gcloud` peut utiliser IAP implicitement en l’absence d’IP publique
- C’est un **vrai modèle Zero Trust**, pas un contournement

---

## Clôture du module

Après validation :

```bash
terraform destroy
```

Objectifs atteints :
- compréhension complète du chemin d’accès
- infra propre et maîtrisée
- base solide pour AKS / GKE / Azure Bastion / Zero Trust

---

**Module 3a : VALIDÉ**
