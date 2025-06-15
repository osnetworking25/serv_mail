# 🔁 Script de restauration SPF & DKIM – Chapitre 4

Ce script `revert_Dkim_Agent_Chap4.sh` permet d’annuler **toutes les modifications apportées au système** par le script d’installation de SPF et DKIM du Chapitre 4. Il est utile si vous souhaitez :

- Réinitialiser la configuration DKIM/SPF
- Corriger des erreurs de configuration
- Supprimer les éléments liés au chapitre 4

---

## 📝 Étapes réalisées par le script

1. **Chargement du fichier de langue** (`fr.sh` ou `en.sh`)  
   Affichage dynamique des messages dans la langue de votre choix (fr/en)

2. **Désinstallation des paquets**  
   Suppression complète de `opendkim`, `opendkim-tools` et `postfix-policyd-spf-python`

3. **Suppression des fichiers de configuration**  
   Suppression des dossiers :  
   - `/etc/opendkim/`  
   - `/etc/postfix/sql/`  
   - `/etc/default/opendkim`  
   - `/var/log/opendkim`

4. **Nettoyage de la configuration Postfix**  
   Suppression des lignes insérées par le script d’installation dans `main.cf` et `master.cf`  
   ainsi que des paramètres `postconf` relatifs aux milters.

5. **Suppression facultative des dossiers `export/` et `backup/`**  
   Une question est posée à l'utilisateur pour confirmer la suppression de ces dossiers situés dans `/opt/serv_mail/chapitre_04/`.

---

## 💡 Améliorations possibles

- Ajouter une vérification plus fine avant suppression de fichiers critiques.
- Ajouter une sauvegarde automatique avant exécution.
- Intégrer une option `--force` ou `--dry-run` pour tester sans supprimer.
- Centraliser toutes les variables dans un fichier `.env` si besoin.

---

## 📁 Emplacement conseillé

Le script est placé dans :

