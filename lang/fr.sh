#!/bin/bash

# 🇫🇷 Fichier de langue – Français

# ==================================================================
# ✅ MESSAGES GENERAUX - Tous chapitres
# ==================================================================

# Les avertissements de locale
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

msg_lang="🌍 Langue sélectionnée : Français"
msg_select_language="🌐 Choisissez votre langue :"
msg_select_english="1) Français"
msg_select_french="2) English"
msg_invalid_choice="❌ Choix invalide. Français sélectionné par défaut."

# Prompts utilisateur communs
msg_prompt_domain="Entrez votre domaine (ex: example.com)"
msg_prompt_mail_from="Adresse email d'expédition"
msg_prompt_mail_dest="Adresse email de destination (test)"
msg_prompt_mail_fqdn="Entrez votre nom de serveur de messagerie FQDN (ex: mail.domain.tld)"
msg_prompt_confirm="Souhaitez-vous continuer ? (o/n)"

# 🔐 Messages généraux pour la gestion de UFW (utilisables partout)

msg_ufw_not_installed="UFW n’est pas installé. Aucun pare-feu actif détecté."
msg_active_ufw="✅ UFW est déjà activé."
msg_inactive_ufw="❌ UFW n'est pas activé sur ce serveur."
msg_ufw_keep_enabled="UFW est activé. Souhaitez-vous le laisser activé ?"
msg_ufw_disabling="Désactivation de UFW en cours"
msg_ufw_disabled="UFW a été désactivé."
msg_enable_ufw="Souhaitez-vous activer UFW pour sécuriser votre serveur ?"
msg_ufw_left_disabled="UFW laissé désactivé."
msg_open_ports="🌐 Ouverture des ports nécessaires dans le pare-feu..."
msg_open_ports_complete_chap2="✅ Les ports ont été ouverts avec succès."
msg_press_enter="Appuyez sur [Entrée] pour continuer..."


# 🔁 MESSAGES GÉNÉRAUX – Restauration / Désinstallation
msg_revert_intro() {
  echo -e "\n\n🔁 Script de restauration SPF & DKIM – Annulation complète"
}

msg_revert_warning() {
  echo -e "\n\n⚠️ Attention : tous les fichiers, paquets et configurations liés à DKIM/SPF ont été supprimés."
}

msg_revert_done() {
  echo -e "\n\n✅ Restauration terminée. La configuration précédente a été supprimée."
}

# 🧹 Nettoyage optionnel (exports / sauvegardes)
ask_optional_cleanup() {
  echo -e "\n\n🗂️ Suppression des exports et sauvegardes (facultatif)"
  echo -e "\n\n"
  read -rp "Souhaitez-vous supprimer les dossiers de backup et export ? (o/N) : " CLEAN_CHOICE
  if [[ \"$CLEAN_CHOICE\" =~ ^[Oo]$ ]]; then
    return 0
  else
    echo \"⏭️ Suppression ignorée.\"
    return 1
  fi
}

# États communs
msg_starting="🚀 Démarrage du script..."
msg_done="✅ Terminé"
msg_error="❌ Une erreur est survenue"

# ==================================================================
#📘 Chapitre 01 - Base Ubuntu + configuration SSH
# ==================================================================

# ------------------------------------------------------------------
# 📘            ------- introduction -------
# ------------------------------------------------------------------

# === BANNIÈRE D’INTRODUCTION ===
msg_banner_chap1() {
  echo "📘 Script de configuration Postfix – Chapitre 01"
}

msg_intro_chap1() {
  echo "🚀 Ce script installe et teste un serveur Postfix de base sur Ubuntu."
}

msg_steps_chap1() {
  echo "🧾 Ce script exécutera toutes les étapes nécessaires à la configuration de Postfix sur Ubuntu (14 étapes incluses dans ce chapitre)."
}

msg_steps_chap1_list() {
  echo -e "
1️⃣  Initialiser le domaine principal
2️⃣  Ajouter le FQDN dans /etc/hosts
3️⃣  Vérifier le hostname système
4️⃣  Vérifier les enregistrements DNS
5️⃣  Mettre à jour le système et installer Postfix
6️⃣  Vérifier l’état du pare-feu
7️⃣  Tester la connexion sortante vers le port 25
8️⃣  Envoyer un email test avec sendmail
9️⃣  Installer Mailutils et tester l’envoi local
🔟  Définir la taille maximale des emails
1️⃣1️⃣  Définir myhostname dans Postfix
1️⃣2️⃣  Créer les alias mail requis
1️⃣3️⃣  Configurer les protocoles IP
1️⃣4️⃣  Mettre à jour Postfix sans écraser la configuration
"
}


# ------------------------------------------------------------------
# 📘 Étape 1 – Initialisation du domaine principal
# ------------------------------------------------------------------
msg_step1_title()  { echo "📘 Étape 1 – Définition du domaine principal"; }
msg_step1_start()  { echo "🔧 Initialisation du domaine principal..."; }
msg_step1_prompt="Nom de domaine principal"
msg_step1_ok="Domaine principal défini"

# ------------------------------------------------------------------
# 🖋️ Étape 2 – Ajout du FQDN dans le fichier /etc/hosts
# ------------------------------------------------------------------
msg_step2_title()  { echo "📘 Étape 2 – Ajout du FQDN dans /etc/hosts"; }
msg_step2_start()  { echo "🖋️ Ajout de l’entrée FQDN dans le fichier hosts..."; }
msg_step2_exists="Entrée déjà présente dans /etc/hosts"
msg_step2_added="Entrée ajoutée"

# ------------------------------------------------------------------
# 🖥️ Étape 3 – Vérification du hostname système
# ------------------------------------------------------------------

msg_step3_title()  { echo "📘 Étape 3 – Vérification du nom d’hôte système"; }
msg_step3_start()  { echo "🔍 Vérification et ajustement du hostname..."; }
msg_step3_current="Nom d’hôte actuel"
msg_step3_prompt="Nouveau nom d’hôte (laisser vide pour conserver)"
msg_step3_set="Nom d’hôte mis à jour"
msg_step3_ok="Nom d’hôte déjà correct"
msg_step3_hostname_invalid="⚠️  Le nom de machine saisi contient des caractères non valides."
msg_step3_hostname_allowed="❌ Seuls les caractères minuscules, les chiffres, les points (.) et tirets (-) sont autorisés."
msg_step3_hostname_kept="⏭️  Nom d'hôte conservé sans modification"


# ------------------------------------------------------------------
# 🌐 Étape 4 – Vérification des enregistrements DNS
# ------------------------------------------------------------------

msg_step4_title()  { echo "📘 Étape 4 – Vérification des enregistrements DNS"; }
msg_step4_start()  { echo "🔍 Vérification DNS..."; }

msg_step4_dns_reminder="Ajoutez les enregistrements DNS suivants chez votre registrar"
msg_step4_dns_examples="Exemples d’enregistrements"

msg_step4_mx_example()     { echo "🔹 MX RECORD\n   @      300 IN MX 10 mail.${DOMAIN}"; }
msg_step4_spf_example()    { echo "🔹 SPF RECORD\n   @      300 IN TXT \"v=spf1 mx -all\""; }
msg_step4_dmarc_example()  { echo "🔹 DMARC RECORD\n   _dmarc 300 IN TXT \"v=DMARC1; p=none; rua=mailto:dmarc@${DOMAIN}; pct=100\""; }

msg_step4_wait_user()  { echo "⏸️  Appuyez sur [Entrée] une fois les DNS ajoutés chez votre registrar..."; }

msg_step4_testing_dns="Tests de propagation DNS en cours..."

msg_step4_mx_title="🔍 Champ MX pour"
msg_step4_spf_title="🔍 Champ SPF pour"
msg_step4_dmarc_title="🔍 Champ DMARC pour"

msg_step4_spf_missing="⚠️  Aucun SPF trouvé."
msg_step4_dmarc_missing="⚠️  Aucun enregistrement DMARC trouvé."

msg_step4_continue="⏸️  Appuyez sur [Entrée] pour continuer..."
msg_step4_success="✅ Enregistrements DNS vérifiés"


# ------------------------------------------------------------------
# 🧰 Étape 5 – Mise à jour du système et installation de Postfix
# ------------------------------------------------------------------

msg_step5_title()        { echo "📘 Étape 5 – Mise à jour et installation de Postfix"; }
msg_step5_start()        { echo "🔧 Début de la mise à jour et de l'installation de Postfix..."; }
msg_step5_update()       { echo "Mise à jour des paquets..."; }
msg_step5_config_info()  { echo "Pendant l'installation, suivez les instructions à l'écran :"; }
msg_step5_config_1()     { echo "   ➤ 1. Sélectionnez : « Site Internet »"; }
msg_step5_config_2()     { echo "   ➤ 2. Entrez votre domaine principal"; }
msg_step5_installing()   { echo "Installation de Postfix en cours..."; }
msg_step5_check_version() { echo "Version de Postfix installée :"; }
msg_step5_check_port()   { echo "Vérification que le port 25 est bien écouté :"; }
msg_step5_port_warning() { echo "❌ Postfix ne semble pas écouter sur le port 25."; }
msg_step5_check_binaries() { echo "Binaires disponibles dans /usr/sbin/ :"; }
msg_step5_success()      { echo "✅ Postfix installé et vérifié avec succès."; }


# ------------------------------------------------------------------
# 🔥 Étape 6 – Vérification de l’état du pare-feu
# ------------------------------------------------------------------

msg_step6_title()              { echo "🔥 Étape 6 – Vérification de l’état du pare-feu (UFW)"; }
msg_step6_success()            { echo "✅ Pare-feu vérifié (UFW)"; }

# ------------------------------------------------------------------
# 📘 Étape 7 – Test de connexion sortante vers port 25 (SMTP)
# ------------------------------------------------------------------

msg_step7_title()          { echo "📘 Étape 7 – Test de connexion sortante vers le port 25 (SMTP)"; }
msg_step7_start()          { echo "🔍 Vérification si le port 25 sortant est ouvert (vers smtp.gmail.com)"; }
msg_step7_smtp_test()      { echo "Test de connexion sortante vers smtp.gmail.com (port 25)..."; }
msg_step7_explanation()    { echo "(Ce test permet de vérifier si votre FAI ou hébergeur ne bloque pas le port 25 sortant)"; }
msg_step7_telnet_missing() { echo "Telnet n’est pas installé. Installation en cours..."; }
msg_step8_verification_ok="Le mail a bien été transmis (status=sent détecté dans les logs)."
msg_step8_verification_fail="Aucun status=sent détecté. Vérifiez votre configuration ou consultez les logs."
msg_step7_success()        { echo "✅ Test SMTP terminé"; }

# ------------------------------------------------------------------
# 📘 Étape 8 – Envoi d’un e-mail de test avec Postfix (sendmail)
# ------------------------------------------------------------------

msg_step8_title()          { echo "📘 Étape 8 – Envoi d’un e-mail de test avec Postfix (sendmail)"; }
msg_step8_start()          { echo "🔍 Test d'envoi d'un message via la commande sendmail"; }
msg_step8_test_sendmail()  { echo "Envoi d’un e-mail de test avec sendmail..."; }
msg_step8_content()        { echo "Contenu : « test email »"; }
msg_step8_dest()           { echo "Destination"; }
msg_step8_local_mailbox()  { echo "Boîte aux lettres locale pour chaque utilisateur"; }
msg_step8_log_hint()       { echo "Pour vérifier les logs Postfix, consultez :"; }
msg_step8_success()        { echo "✅ Envoi du mail terminé"; }


# ------------------------------------------------------------------
# 📘 Étape 9 – Installation de Mailutils et test d’envoi local
# ------------------------------------------------------------------

msg_step9_title()           { echo "📘 Étape 9 – Installation de Mailutils et test d’envoi local"; }
msg_step9_start()           { echo "📦 Installation de mailutils et test local en cours..."; }
msg_step9_installing="Installation de mailutils (agent utilisateur de messagerie)..."
msg_step9_sending="Envoi d’un e-mail local avec Mailutils..."
msg_step9_subject_display="Sujet de l'e-mail"
msg_step9_mail_subject="✅ Test Chapitre 1"
msg_step9_mail_body="✅ Postfix fonctionne – test Chapitre 1\n\nHôte : $(hostname)"
msg_step9_ask_received="Avez-vous reçu le mail de test ?"
msg_step9_received="le mail a bien été reçu ✅"
msg_step9_not_received="le mail ne semble pas reçu. Nous vérifierons à la fin du chapitre."
msg_step9_success()         { echo "✅ Test avec mailutils terminé"; }




# ------------------------------------------------------------------
# 📘 Étape 10 – Définir la taille maximale des e-mails (message_size_limit)
# ------------------------------------------------------------------

msg_step10_title()       { echo "📘 Étape 10 – Définir la taille maximale des e-mails (message_size_limit)"; }
msg_step10_start()       { echo "🔧 Configuration de la taille maximale autorisée pour les e-mails..."; }
msg_step10_current="Taille actuelle autorisée pour un e-mail"
msg_step10_box_limit="Limite actuelle de taille de boîte mail (mailbox_size_limit)"
msg_step10_warn_box="⚠️ ATTENTION : la taille du message dépasse la taille maximale autorisée pour la boîte mail."
msg_step10_confirm_apply="Voulez-vous quand même appliquer cette valeur ?"
msg_step10_abort="Changement annulé."
msg_step10_ask_size="Nouvelle taille maximale pour un e-mail (en octets)"
msg_step10_applied="Taille maximale mise à jour"
msg_step10_default="Valeur conservée"
msg_step10_success()     { echo "✅ Étape 10 terminée."; }


# ------------------------------------------------------------------
# 📘 Étape 11 – Définir myhostname dans Postfix (FQDN recommandé)
# ------------------------------------------------------------------

msg_step11_title()          { echo "📘 Étape 11 – Définir myhostname dans Postfix (FQDN du serveur mail)"; }
msg_step11_current()        { echo "Nom actuel (myhostname dans Postfix)"; }
msg_step11_prompt()         { echo "Entrez le nom d’hôte FQDN complet du serveur (myhostname)"; }
msg_step11_warn_apex()      { echo "Attention : vous utilisez le domaine principal. Ce n’est pas recommandé."; }
msg_step11_suggest_fqdn()   { echo "Utilisez un sous-domaine FQDN comme mail.domain.tld."; }
msg_step11_applied()        { echo "Nom FQDN appliqué avec succès dans la configuration Postfix"; }
msg_step11_success()        { echo "✅ Étape 11 terminée."; }
msg_step11_comment_header="👇 Déclaré dans le script Chapitre 1 – Configuration Postfix"


# ------------------------------------------------------------------
# 📘 Étape 12 – Création des alias mail requis (RFC 2142)
# ------------------------------------------------------------------

msg_step12_title()           { echo "📘 Étape 12 – Création des alias mail requis (RFC 2142)"; }
msg_step12_prompt_alias()    { echo "Quel utilisateur recevra les mails système ?"; }
msg_step12_add_postmaster()  { echo "➕ Alias ajouté : postmaster → root"; }
msg_step12_root_modified()   { echo "✅ Alias modifié : root →"; }
msg_step12_no_change()       { echo "ℹ️ Aucun alias personnalisé fourni. L’alias root reste inchangé."; }
msg_step12_newaliases()      { echo "✅ Table des alias mise à jour avec succès."; }
msg_step12_success()         { echo "✅ Étape 12 terminée."; }



# ------------------------------------------------------------------
# 📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)
# ------------------------------------------------------------------

msg_step13_title()        { echo "📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)"; }
msg_step13_current()      { echo "Protocole(s) IP actuellement configuré(s) (inet_protocols)"; }
msg_step13_explain()      { echo "Choisissez les protocoles IP que Postfix doit utiliser :"; }
msg_step13_prompt_choice() { echo "Votre choix (1=IPv4, 2=IPv6, 3=les deux)"; }
msg_step13_keep_default="laisser par défaut"
msg_step13_comment="Protocole IP défini par le script Chapitre 1"
msg_step13_set_ipv4="✅ inet_protocols défini sur ipv4"
msg_step13_set_ipv6="✅ inet_protocols défini sur ipv6"
msg_step13_set_all="✅ inet_protocols défini sur all"
msg_step13_keep="ℹ️ Aucun changement effectué. Valeur actuelle conservée"
msg_step13_restart="🔄 Redémarrage de Postfix après modification de inet_protocols..."
msg_step13_success()      { echo "✅ Étape 13 terminée."; }
msg_press_enter_word="Entrée"



# ------------------------------------------------------------------
# 📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)
# ------------------------------------------------------------------

msg_step14_title() { echo "📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)"; }
msg_step14_update_notice() { echo "Mise à jour de Postfix et des paquets disponibles..."; }
msg_step14_upgrade_tip1() { echo "🧠 Lorsque la mise à jour vous propose de choisir une configuration, sélectionnez :"; }
msg_step14_upgrade_tip2() { echo "➤ « ❌ Aucun (No configuration) » pour préserver vos fichiers actuels."; }
msg_step14_success() { echo "✅ Étape 14 terminée."; }

# ------------------------------------------------------------------
# 📘 Étape 15 – Sauvegarde main.cf (non destructif)
# ------------------------------------------------------------------
msg_step15_title() { echo "📘 Étape 15 – Sauvegarde du fichier main.cf (copie non destructive)"; }
msg_step15_success() { echo "✅ Fichier main.cf sauvegardé avec succès."; }

# ------------------------------------------------------------------
# 📘 Étape 16 – Redémarrage Postfix
# ------------------------------------------------------------------
msg_step16_title() { echo "📘 Étape 16 – Redémarrage du service Postfix"; }
msg_step16_success() { echo "✅ Postfix redémarré avec succès."; }


# ==========================================================
# 🧹 Script de désinstallation – Chapitre 1 (Postfix Basique)
# 📦 Suppression des modifications effectuées par le chapitre 1
# ==========================================================
msg_uninstall_intro="🧹 Ce script supprime proprement la configuration effectuée dans le Chapitre 1."
msg_uninstall_backup="Sauvegarde des fichiers avant suppression..."
msg_uninstall_clean_hosts="Nettoyage de la ligne 127.0.1.1 dans /etc/hosts..."
msg_uninstall_clean_maincf="Nettoyage du fichier main.cf (myhostname, inet_protocols, message_size_limit)..."
msg_uninstall_clean_aliases="Nettoyage des alias postmaster: et root:..."
msg_uninstall_ask_remove_postfix="Souhaitez-vous supprimer complètement Postfix ?"
msg_prompt_yes_no_default="Oui/Non (défaut : Non)"
msg_uninstall_removing="Suppression de Postfix en cours..."
msg_uninstall_removed="Postfix a été supprimé avec succès."
msg_uninstall_not_installed="Postfix n’est pas installé. Aucune action effectuée."
msg_uninstall_skipped="Suppression de Postfix ignorée."
msg_uninstall_success="✅ Fin du script de désinstallation – Chapitre 1"


# ============================================================
# 📦 Script de sauvegarde – Chapitre 01 – Postfix/Dovecot de base
# ============================================================

msg_lang_chap1="🌍 Langue sélectionnée : Français"
msg_banner_chap1="📘 Sauvegarde Chapitre 01 – Configuration de base du serveur mail"
msg_intro_chap1="💾 Ce script sauvegarde les fichiers essentiels modifiés lors du Chapitre 1"
msg_prompt_domain_chap1="Entrez votre nom de domaine principal (ex : domain.tld)"
msg_backup_start_chap1="📦 Sauvegarde en cours..."
msg_backup_success_chap1="✅ Sauvegarde terminée avec succès"
msg_backup_fail_chap1="❌ La sauvegarde a échoué. Vérifiez les logs pour plus d'informations"
msg_end_chap1="✅ Fin du script de sauvegarde – Chapitre 1"



# ==================================================================
#📘 Chapitre 02 - Installation de Postfix et Dovecot
# ==================================================================


# ------------------------------------------------------------------
# 📘 Introduction et étapes
# ------------------------------------------------------------------

msg_intro_chap2="🎉 Bienvenue dans le script d'installation de votre serveur de messagerie sécurisé avec Postfix et Dovecot."
msg_steps_chap2="📜 Ce script va suivre les étapes suivantes :
1. Vérification de l'état de **UFW** (pare-feu) et activation si nécessaire.
2. Ouverture des ports nécessaires pour la gestion des emails.
3. Installation de **Postfix** pour la gestion des emails sortants (SMTP).
4. Installation de **Dovecot** pour la gestion des emails entrants (IMAP/POP3).
5. Activation du chiffrement **TLS** pour sécuriser les communications.
6. Tests pour vérifier la bonne configuration des services."


msg_banner_chap2="###########################################\n💼 Postfix & Dovecot – Mail Server Setup 💼\n###########################################"

# ------------------------------------------------------------------
# 📘 Messages d'état pour UFW et ouverture des ports
# ------------------------------------------------------------------

msg_active_ufw_chap2="✅ UFW est déjà activé."
msg_inactive_ufw_chap2="❌ UFW n'est pas activé sur ce serveur."
msg_enable_ufw_chap2="Souhaitez-vous activer UFW pour sécuriser votre serveur ? (y/n)"
msg_open_ports_chap2="🌐 Ouverture des ports nécessaires dans le pare-feu..."
msg_open_ports_complete_chap2="✅ Les ports ont été ouverts avec succès."

# ------------------------------------------------------------------
# 📘 Messages de confirmation pour l'installation et les tests
# ------------------------------------------------------------------
msg_install_postfix_chap2="🌐 Installation de Postfix..."
msg_install_dovecot_chap2="🌐 Installation de Dovecot..."
msg_test_email_chap2="🌐 Test de l'envoi d'un email via Postfix. Vous allez entrer le **sujet** et la **description** de l'email."
msg_prompt_subject="Veuillez entrer le sujet de l'email"
msg_prompt_description="Veuillez entrer la description de l'email"
msg_test_imap_chap2="🌐 Test de la connexion IMAP via Dovecot..."
msg_restart_services_chap2="🌐 Redémarrage de Postfix et Dovecot..."
msg_success_chap2="🎉 Configuration du serveur mail terminée avec succès !"

# ------------------------------------------------------------------
# 📘 Messages pour vérifier l'état des services
# ------------------------------------------------------------------
msg_config_test_postfix_chap2="🌐 Vérification de la configuration de Postfix..."
msg_config_test_dovecot_chap2="🌐 Vérification de la configuration de Dovecot..."

# ------------------------------------------------------------------
# 📘 Nouveaux messages dynamiques à ajouter
# ------------------------------------------------------------------
msg_check_ufw_chap2="🌐 Vérification de l'état de UFW (pare-feu)..."
msg_postfix_config_chap2() { echo "Configuration de Postfix avec le domaine $DOMAIN..."; }
msg_dovecot_maildir_config_chap2="Configuration de Dovecot pour Maildir..."
msg_dovecot_tls_config_chap2="Configuration de Dovecot pour TLS..."

# ============================================================
# 📘 MESSAGES – Chapitre 3 : PostfixAdmin + Comptes virtuels
# ============================================================

msg_banner_chap3="📘 Chapitre 3 – PostfixAdmin et boîtes aux lettres virtuelles"
msg_intro_chap3="📦 Ce script configure PostfixAdmin, les boîtes mail virtuelles, et la base de données pour la gestion multi-domaine."
msg_steps_chap3="📜 Étapes :
1. Installation de MariaDB et création de la base.
2. Configuration de Postfix pour les comptes virtuels.
3. Configuration de Dovecot avec l'authentification SQL.
4. Installation de PostfixAdmin.
5. Création d’un domaine et d’un utilisateur."

msg_install_mariadb_chap3="📦 Installation de MariaDB..."
msg_create_db_chap3="🗃️ Création de la base et des tables..."
msg_config_postfix_sql_chap3="⚙️ Configuration Postfix SQL..."
msg_config_dovecot_sql_chap3="⚙️ Configuration Dovecot SQL..."
msg_install_postfixadmin_chap3="📦 Installation de PostfixAdmin..."
msg_add_domain_user_chap3="➕ Ajout du domaine et d’un compte mail..."
msg_success_chap3="🎉 Chapitre 3 terminé avec succès !"

# ============================================================
# 📘 MESSAGES – Chapitre 4 : SPF & DKIM
# ============================================================

msg_banner_chap4="📘 Chapitre 4 – Configuration SPF & DKIM"
msg_intro_chap4="🔐 Ce script configure SPF, installe OpenDKIM, et signe vos emails automatiquement."
msg_steps_chap4="📜 Étapes :
1. Création de l'entrée SPF DNS.
2. Installation de postfix-policyd-spf-python.
3. Installation d’OpenDKIM.
4. Création des clés publiques/privées.
5. Ajout des tables de signature.
6. Test de la signature DKIM."

# (… ajouter ici tous les msg_stepX_chap4 utilisés dans le script dkim)

msg_success_chap4="🎉 SPF & DKIM configurés avec succès !"

# ============================================================
# 📘 Chapitres suivants (placeholders à remplir au fur et à mesure)
# ============================================================

# msg_intro_chap5="..."
# msg_steps_chap5="..."
# msg_intro_chap6="..."
# msg_intro_chap7="..."
# ...
