# 04_transfer_gcp_to_azure_zero_trust.md

## Objectif
Transposer le modèle **Zero Trust mis en œuvre sur GCP** (VM + IAP + firewall) vers **Azure**, pour :
- des **VM Azure**
- un **cluster AKS**
- en conservant les mêmes principes d’architecture et de sécurité

Ce document sert de **pont conceptuel et Terraform** entre :
- GCP (SFEIR Terraform GCP)
- Azure (VM, AKS, Bastion, Entra ID)

---

## 1. Rappel du modèle validé sur GCP

Sur GCP, le modèle validé est le suivant :

- VM **sans IP publique**
- Accès **uniquement via IAP**
- Firewall restreignant l’entrée :
  - TCP
  - port 22
  - source = plage IP IAP
- Authentification et autorisation **gérées par IAM**
- Aucun accès réseau direct

👉 Le réseau **ne décide pas qui entre**, il valide seulement le **chemin autorisé**.

---

## 2. Équivalence directe GCP ↔ Azure (VM)

| GCP              | Azure                 | Rôle réel                |
|------------------|-----------------------|--------------------------|
| VM sans Public IP| VM sans Public IP     | no network access par défaut |
| IAP              | **Azure Bastion**     | Bastion / proxy managé   |
| Firewall GCP     | **NSG**               | Filtrage réseau          |
| IAM              | **EntraID(Azure AD)** | Identité et autorisation |

👉 **Azure Bastion est l’équivalent fonctionnel direct de GCP IAP.**

---

## 3. Modèle Zero Trust sur VM Azure

### 3.1 Principe
- La VM n’a **pas d’IP publique**
- Azure Bastion est le **seul point d’entrée**
- Le NSG autorise uniquement le trafic provenant du Bastion
- L’utilisateur est authentifié via **Entra ID**

### 3.2 Équivalent conceptuel Terraform (simplifié)

```hcl
resource "azurerm_network_security_rule" "allow_bastion_ssh" {
  name                        = "allow-bastion-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "AzureBastion"
  destination_port_range      = "22"
}
```

---

## 4. Transposition vers AKS (changement d’échelle, pas de modèle)

### 4.1 Équivalence VM ↔ AKS

| VM            | AKS |
|---            |---                     |
| SSH           | API Kubernetes         |
| IAP / Bastion | API Server privé       |
| Firewall      | NSG / Network Policies |
| IAM           | Entra ID + RBAC        |

---

### 4.2 Modèle AKS Zero Trust

- Cluster AKS **privé**
- API Server **non exposé publiquement**
- Accès via :
  - Entra ID
  - RBAC Kubernetes
  - Bastion / Private Endpoint
- Aucune dépendance à une IP client

👉 Même logique :
> **l’identité prime sur le réseau**

---

## 5. Lien direct avec le projet RNCP / Data Platform

Ce modèle s’applique directement à :

- Services Go déployés dans AKS
- APIs d’ingestion / exposition
- Accès aux jobs data / ML
- Accès PostgreSQL / Storage via Private Endpoint
- Séparation claire :
  - identité
  - réseau
  - autorisation

---

## 6. Points clés à retenir

- GCP IAP et Azure Bastion implémentent **le même modèle Zero Trust**
- Terraform est le **langage commun**
- Les noms changent, **le modèle reste**
- AKS est une continuité logique, pas un saut conceptuel

---

## Conclusion

Le travail réalisé sur le repo SFEIR GCP :
- est **pleinement transférable**
- renforce directement la maîtrise Azure / AKS
- constitue une base solide pour le projet RNCP
- prépare les discussions techniques en contexte entreprise

**Ce n’est pas un détour, c’est une fondation.**
