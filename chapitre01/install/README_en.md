# 📘 Chapter 1 – Installation and Configuration of Postfix (Base)

This script installs and configures **Postfix** for basic mail server functionality, following the **LinuxBabe** guide, with additional professional improvements for production use.

---

## 🎯 Objective

The goal of this chapter is to install and configure a **Postfix** server for handling outgoing emails (SMTP). The script will guide you through the initial setup, domain configuration, and ensure that the server is ready for secure mail communication.

---

## ⚙️ Prerequisites

Before running the script, make sure you have the following:

- A **valid domain name** (e.g., `example.com`).
- **Ubuntu server** (ideally version 20.04 or higher).
- **SSL/TLS certificate** (e.g., from **Let's Encrypt**).
- **Sudo privileges** to execute installation commands.

---

## 🧱 Directory Structure

The script organizes files and directories as follows:

/opt/serv_mail/
├── chapitre_01
│ ├── backup/ # Backup folder
│ ├── documentation/ # Documentation files
│ │ ├── README.md # Main README (in English)
│ │ └── README_fr.md # README in French
│ ├── export/ # Directory for exporting files
│ ├── install/ # Installation scripts
│ │ └── install_postfix_base_chap1.sh # Main installation script for Postfix
│ ├── logs/ # Logs generated during installation
│ ├── maintenance/ # Maintenance scripts
│ │ └── uninstall_postfix_base_chap1.sh # Script for uninstallation
│ ├── README.md # Documentation in English
│ └── README_fr.md # Documentation in French

---

## 🚀 Running the Script

### 1. 📁 Verify the location of the script

The script should be placed in the `/opt/serv_mail/chapitre_01/` directory.

### 2. ✅ Make it executable

Ensure the script is executable by running the following command:

```bash
chmod +x install_postfix_base_chap1.sh
```
###  3. ▶️ Run the script

Once the script is executable, run it with the following command:

```bash
sudo ./install_postfix_base_chap1.sh
```

The script will perform the following tasks:

Configure the domain and hostname.

Add the Fully Qualified Domain Name (FQDN) to /etc/hosts.

Verify DNS records (MX, SPF, DMARC).

Update the system and install Postfix.

Configure Postfix for secure mail communication.

###  4.🔍 Automated Steps

The following steps are automated by the script:

Domain Initialization: The script prompts for the main domain and configures it.

FQDN Setup: It adds the Fully Qualified Domain Name (FQDN) to /etc/hosts.

System Hostname Configuration: The script checks and configures the system hostname.

DNS Record Check: It provides instructions for setting up DNS records (MX, SPF, DMARC).

System Update: The system is updated, and Postfix is installed.

Postfix Configuration: Basic Postfix settings are applied.

Test: The script tests the email system by sending a test email via Postfix.

###  5.🗂️ Generated Files
The script generates or modifies the following files:

/etc/postfix/main.cf : Main configuration file for Postfix.

/etc/aliases : Alias configuration file for Postfix.

🧩 Next Steps
Once Chapter 1 is complete, you can:

Configure a mail client to send and receive emails via Postfix.

Set up additional mail management tools, such as PostfixAdmin, to manage users and aliases.

Proceed to Chapter 2 to install and configure Dovecot and secure the server with TLS encryption.

###  6.🧑💼 Authors
Author: pontarlier-informatique

Project: Osnetworking

Date: 14/06/2025

###  7.🌐 Reference
Osnetworking Guide – Chapter 1


---

### Explication des sections :

1. **Objective** : Cette section explique clairement l'objectif du **Chapitre 1**, qui est d'installer **Postfix** pour la gestion des emails sortants.
2. **Prerequisites** : Liste les prérequis nécessaires pour exécuter le script, comme un serveur Ubuntu, un domaine valide, et un certificat SSL/TLS.
3. **Directory Structure** : Présente la structure des répertoires et des fichiers générés par le script.
4. **Running the Script** : Guide l'utilisateur sur la manière de rendre le script exécutable et de le lancer.
5. **Automated Steps** : Détaille les étapes que le script exécute automatiquement, telles que la configuration du domaine, l'ajout du FQDN, la configuration de **Postfix**, etc.
6. **Generated Files** : Liste des fichiers modifiés ou générés par le script, comme **main.cf** et **aliases**.
7. **Next Steps** : Explique ce que l'utilisateur doit faire une fois le script terminé, comme configurer un client de messagerie ou passer au **Chapitre 2**.
8. **Authors** : Détails sur l'auteur du projet.
9. **Reference** : Inclut une référence au **Chapitre 1** du guide d'Osnetworking, s'il est disponible.

---

### Conclusion :

Avec cette **version anglaise du README.md**, tu disposes d'un guide complet pour **Chapitre 1**, expliquant ce que le script fait, comment l'exécuter, et où il place les fichiers générés. Si tu souhaites ajouter des sections ou apporter des modifications supplémentaires, n'hésite pas à me le dire ! 😊
