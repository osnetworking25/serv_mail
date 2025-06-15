#!/bin/bash

# 🇫🇷 Fichier de langue – Français

# ✅ 🌍 Silencer les avertissements de locale
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Message d’introduction (appelé après le choix de la langue)
msg_lang() {
  echo -e "\n📘 Bienvenue dans le script Chapitre 4 – SPF & DKIM"
  echo "ℹ️  Ce script vous guide pas à pas dans la configuration de SPF, DKIM, et DMARC pour votre serveur de mail."
}

# Utilisé pour : Chapitre 1 – 

# === BANNIÈRE D’INTRODUCTION ===
msg_banner() {
  echo "📘 Script de configuration Postfix – Chapitre 1"
}

msg_intro() {
  echo "🚀 Ce script installe et teste un serveur Postfix de base sur Ubuntu."
}
# === PROMPTS DYNAMIQUES ===
msg_prompt_domain="Entrez votre nom de domaine principal (ex: domain.tld)"
msg_prompt_mail_from="Adresse e-mail de l’expéditeur"
msg_prompt_mail_dest="Adresse e-mail de destination pour les tests"
msg_prompt_mail_fqdn="Nom FQDN du serveur mail (ex: mail.domain.tld)"

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


# ------------------------------------------------------------------
# 🌐 Étape 4 – Vérification des enregistrements DNS
# ------------------------------------------------------------------

msg_step4_title()  { echo "📘 Étape 4 – Vérification des enregistrements DNS"; }
msg_step4_start()  { echo "🔍 Vérification DNS..."; }
msg_step4_dns_reminder="Ajoutez les enregistrements DNS suivants chez votre registrar"
msg_step4_dns_examples="Exemples d’enregistrements"
msg_step4_testing_dns="Tests de propagation DNS en cours..."
msg_step4_continue="Appuyez sur Entrée pour continuer..."
msg_step4_success="✅ Enregistrements DNS vérifiés"

#---------------------------------#
# ✅ Partie 5 – Mise à jour du système et installation de Postfix    #
#---------------------------------#

msg_step5_title()  { echo "📘 Étape 5 – Mise à jour et installation de Postfix"; }
msg_step5_start()        { echo "🔧 Début de la mise à jour et de l'installation de Postfix"; }
msg_step5_update()       { echo "Mise à jour des paquets..."; }
msg_step5_config_info()  { echo "Pendant l'installation, suivez les instructions à l'écran."; }
msg_step5_installing()   { echo "Installation de Postfix en cours..."; }
msg_step5_check_version="Version de Postfix installée"
msg_step5_check_port="Vérification que le port 25 est bien écouté"
msg_step5_check_binaries="Binaires disponibles dans /usr/sbin/"
msg_step5_success()      { echo "✅ Postfix installé et vérifié avec succès."; }


# ------------------------------------------------------------------
# 🔥 Étape 6 – Vérification de l’état du pare-feu
# ------------------------------------------------------------------

msg_step6_title()              { echo "🔥 Étape 6 – Vérification de l’état du pare-feu (UFW)"; }
msg_step6_start()              { echo "🔍 Vérification de l'état du pare-feu UFW..."; }
msg_step6_confirm_continue()   { echo "Appuyez sur Entrée pour continuer"; }
msg_step6_success()            { echo "✅ Pare-feu vérifié (UFW)"; }

# ------------------------------------------------------------------
# 📘 Étape 7 – Test de connexion sortante vers port 25 (SMTP)
# ------------------------------------------------------------------

msg_step7_title()         { echo "📘 Étape 7 – Test de connexion sortante vers le port 25 (SMTP)"; }
msg_step7_start()         { echo "🔍 Vérification si le port 25 sortant est ouvert (vers smtp.gmail.com)"; }
msg_step7_smtp_test()     { echo "Test de connexion sortante vers smtp.gmail.com (port 25)..."; }
msg_step7_explanation()   { echo "(Ce test permet de vérifier si votre FAI ou hébergeur ne bloque pas le port 25 sortant)"; }
msg_step7_telnet_missing(){ echo "Telnet n’est pas installé. Installation en cours..."; }
msg_step7_success()          { echo "✅ Test SMTP terminé"; }

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
msg_step8_success()           { echo "✅ Envoi du mail terminé"; }

# ------------------------------------------------------------------
# 📘 Étape 9 – Installation de Mailutils et test d’envoi local
# ------------------------------------------------------------------

msg_step9_title()  { 
echo "📘 Étape 9 – Installation de Mailutils et test d’envoi local";
}

msg_step9_start()  {
 echo "📦 Installation de mailutils et test local en cours..."; 
 }
 
msg_step9_ask_received="Avez-vous reçu le mail de test ?"
msg_step9_success"✅ Test avec mailutils terminé"

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
msg_step10_success()        { echo "✅ Étape 10 terminée."; }

# ------------------------------------------------------------------
# 📘 Étape 11 – Définir myhostname dans Postfix (FQDN recommandé)
# ------------------------------------------------------------------

msg_step11_title() { echo "📘 Étape 11 – Définir myhostname dans Postfix (FQDN du serveur mail)"; }
msg_step11_current() { echo "Nom actuel (myhostname dans Postfix)"; }
msg_step11_prompt() { echo "Entrez le nom d’hôte FQDN complet du serveur (myhostname)"; }
msg_step11_warn_apex() { echo "Attention : vous utilisez le domaine principal. Ce n’est pas recommandé."; }
msg_step11_suggest_fqdn() { echo "Utilisez un sous-domaine FQDN comme mail.domain.tld."; }
msg_step11_applied() { echo "Nom FQDN appliqué avec succès dans la configuration Postfix"; }
msg_step11_success() { echo "✅ Étape 11 terminée."; }


# ------------------------------------------------------------------
# 📘 Étape 12 – Création des alias mail requis (RFC 2142)
# ------------------------------------------------------------------

msg_step12_title() { echo "📘 Étape 12 – Création des alias mail requis (RFC 2142)"; }
msg_step12_prompt_alias() { echo "Quel utilisateur recevra les mails système ?"; }
msg_step12_success() { echo "✅ Étape 12 terminée."; }

# ------------------------------------------------------------------
# 📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)
# ------------------------------------------------------------------

msg_step13_title() { echo "📘 Étape 13 – Configuration des protocoles IP (IPv4 / IPv6)"; }
msg_step13_current() { echo "Protocole(s) IP actuellement configuré(s) (inet_protocols)"; }
msg_step13_explain() { echo "Choisissez les protocoles IP que Postfix doit utiliser :"; }
msg_step13_prompt_choice() { echo "Votre choix (1=IPv4, 2=IPv6, 3=les deux)"; }
msg_step13_restart() { echo "Redémarrage de Postfix après modification de inet_protocols..."; }
msg_step13_success() { echo "✅ Étape 13 terminée."; }

# ------------------------------------------------------------------
# 📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)
# ------------------------------------------------------------------

msg_step14_title() { echo "📘 Étape 14 – Mise à jour de Postfix (préserver la configuration)"; }
msg_step14_update_notice() { echo "Mise à jour de Postfix et des paquets disponibles..."; }
msg_step14_success() { echo "✅ Étape 14 terminée."; }


# ==========================================================
# 🧹 Script de désinstallation – Chapitre 1 (Postfix Basique)
# 📦 Suppression des modifications effectuées par le chapitre 1
# ==========================================================
msg_uninstall_intro() {
  echo "🧹 Démarrage du processus de désinstallation (Chapitre 1)..."
}

msg_uninstall_done() {
  echo "✅ Désinstallation terminée. Vos fichiers ont été sauvegardés dans : $BACKUP_DIR"
}

msg_uninstall_ask_remove_postfix="Souhaitez-vous supprimer complètement Postfix ?"
msg_uninstall_removed="a été supprimé"
msg_uninstall_skipped="n’a pas été supprimé"




# Chapitre 2 - Installation de Postfix et Dovecot

# Introduction et étapes

msg_intro_chap2="🎉 Bienvenue dans le script d'installation de votre serveur de messagerie sécurisé avec Postfix et Dovecot."
msg_steps_chap2="📜 Ce script va suivre les étapes suivantes :
1. Vérification de l'état de **UFW** (pare-feu) et activation si nécessaire.
2. Ouverture des ports nécessaires pour la gestion des emails.
3. Installation de **Postfix** pour la gestion des emails sortants (SMTP).
4. Installation de **Dovecot** pour la gestion des emails entrants (IMAP/POP3).
5. Activation du chiffrement **TLS** pour sécuriser les communications.
6. Tests pour vérifier la bonne configuration des services."

# Messages pour la sélection de la langue

msg_select_language_chap2="🌐 Choisissez votre langue :"
msg_select_english_chap2="1) Français"
msg_select_french_chap2="2) English"
msg_prompt_domain_chap2="Entrez votre domaine (ex: example.com)"
msg_prompt_mail_fqdn_chap2="Entrez votre nom de serveur de messagerie FQDN (ex: mail.${DOMAIN})"
msg_banner_chap2="###########################################\n💼 Postfix & Dovecot – Mail Server Setup 💼\n###########################################"

# Messages d'état pour UFW et ouverture des ports

msg_active_ufw_chap2="✅ UFW est déjà activé."
msg_inactive_ufw_chap2="❌ UFW n'est pas activé sur ce serveur."
msg_enable_ufw_chap2="Souhaitez-vous activer UFW pour sécuriser votre serveur ? (y/n)"
msg_open_ports_chap2="🌐 Ouverture des ports nécessaires dans le pare-feu..."
msg_open_ports_complete_chap2="✅ Les ports ont été ouverts avec succès."

# Messages de confirmation pour l'installation et les tests

msg_install_postfix_chap2="🌐 Installation de Postfix..."
msg_install_dovecot_chap2="🌐 Installation de Dovecot..."
msg_test_email_chap2="🌐 Test de l'envoi d'un email via Postfix. Vous allez entrer le **sujet** et la **description** de l'email."
msg_prompt_subject="Veuillez entrer le sujet de l'email"
msg_prompt_description="Veuillez entrer la description de l'email"
msg_test_imap_chap2="🌐 Test de la connexion IMAP via Dovecot..."
msg_restart_services_chap2="🌐 Redémarrage de Postfix et Dovecot..."
msg_success_chap2="🎉 Configuration du serveur mail terminée avec succès !"

# Messages pour vérifier l'état des services

msg_config_test_postfix_chap2="🌐 Vérification de la configuration de Postfix..."
msg_config_test_dovecot_chap2="🌐 Vérification de la configuration de Dovecot..."

# Nouveaux messages dynamiques à ajouter

msg_check_ufw_chap2="🌐 Vérification de l'état de UFW (pare-feu)..."
msg_postfix_config_chap2="Configuration de Postfix avec le domaine $DOMAIN..."
msg_dovecot_maildir_config_chap2="Configuration de Dovecot pour Maildir..."
msg_dovecot_tls_config_chap2="Configuration de Dovecot pour TLS..."





# Utilisé pour : Chapitre 3 – 


# Utilisé pour : Chapitre 4 – SPF & DKIM (installation) dossier Script

# ✅ === MESSAGES POUR INSTALLATION ===

msg_banner() {
  echo -e "\n\n 📘 Script de configuration SPF & DKIM - Chapitre 4"
}

msg_intro() {
  echo "📬 Script de configuration SPF et DKIM basé sur LinuxBabe (version adaptée dynamique)"
  echo "📚 Étapes :"
  echo "  1. Enregistrement DNS SPF"
  echo "  2. Installation de postfix-policyd-spf-python"
  echo "  3. Installation d’OpenDKIM"
  echo "  4. Création des fichiers de table (signing, key, trusted)"
  echo "  5. Génération de la paire de clés DKIM"
  echo "  6. Publication de la clé publique DKIM dans le DNS"
  echo "  7. Test de la clé avec opendkim-testkey"
  echo "  8. Connexion OpenDKIM ↔️ Postfix via socket Unix"
  echo "  9. Vérification finale SPF & DKIM avec swaks/dig"
}

# ✅ === 🔧 Variables dynamiques principales ===

msg_domain_request() {
  echo -n "🌐 Nom de domaine principal (ex: domain.tld) : "
}

msg_mailfrom_request() {
  echo -n "📧 Adresse e-mail utilisée pour les tests (ex: postmaster@${DOMAIN}) : "
}

msg_maildest_request() {
  echo -n "📨 Adresse de destination pour les tests (ex: Gmail, Outlook) : "
}

msg_fqdn_request() {
  echo -n "🌐 FQDN du serveur (ex: mail.${DOMAIN}) : "
}


#---------------------------------#
# ✅ Partie 1 – SPF DNS Record    #
#---------------------------------#

# === Étape 1 – Enregistrement DNS SPF ===

msg_step1_title() {
  echo -e "\n📘 Étape 1 - Enregistrement SPF dans le DNS"
}

msg_step1_instruction() {
  echo "Veuillez ajouter le champ TXT suivant dans la zone DNS de votre domaine ${DOMAIN} :"
  echo
  echo "   Nom   : @"
  echo "   Type  : TXT"
  echo "   Valeur: v=spf1 mx ~all"
  echo
  echo "💡 Ce champ indique que seuls les serveurs MX de ${DOMAIN} sont autorisés à envoyer des e-mails pour ce domaine."
  echo "🕒 Attendez la propagation DNS avant de poursuivre."
}

msg_step1_continue_prompt() {
  echo -n "✅ Appuyez sur Entrée lorsque l'enregistrement SPF est ajouté et propagé..."
}

msg_step1_dig_check() {
  echo "🔍 Vérification DNS en cours avec dig..."
}

msg_step1_confirm_prompt() {
  echo -n "👁️ Avez-vous visuellement confirmé la présence du champ SPF ? (O/N) : "
}

msg_step1_confirmed() {
  echo "✅ Enregistrement SPF confirmé par l'utilisateur."
}

msg_step1_not_confirmed() {
  echo "⚠️ Étape 1 non validée. Vous pouvez relancer cette étape plus tard."
}

msg_step1_success() {
  echo -e "\n\n✅ Enregistrement SPF vérifié. Étape 1 terminée avec succès."
}


#--------------------------------------------------#
# ✅ Partie 2 – Installation du SPF Policy Agent   #
#--------------------------------------------------#

msg_step2_title() {
  echo -e "\n\n📘 Étape 2 - Installation de postfix-policyd-spf-python"
}

msg_step2_check_installed() {
  echo -e "\n\n🔍 Vérification de la présence du paquet..."
}

msg_step2_already_installed() {
  echo -e "\n\n📦 Le paquet postfix-policyd-spf-python est déjà installé."
}

msg_step2_installing() {
  echo -e "\n\n📥 Installation du paquet requis..."
}

msg_step2_success() {
  echo -e "\n\n✅ SPF Policy Agent installé avec succès."
}

msg_step2_failure() {
  echo -e "\n\n❌ Échec de l’installation de postfix-policyd-spf-python."
}

#---------------------------------------#
# ✅ Partie 3 – Installation OpenDKIM   #
#---------------------------------------#

msg_step3_title() {
  echo -e "\n📘 Étape 3 - Installation d'OpenDKIM"
}

msg_step3_start() {
  echo "🔧 Création des dossiers et fichiers de base pour OpenDKIM"
}

msg_step3_success() {
  echo "✅ Étape 3 terminée : OpenDKIM installé et fichier de configuration mis à jour."
}

#---------------------------------#
# ✅ Partie 4 – Tables DKIM       #
#---------------------------------#

msg_step4_title() {
  echo -e "\n📘 Étape 4 - Création des fichiers signing.table, key.table et trusted.hosts"
}

msg_step4_prepare_dirs() {
  echo "📂 Préparation des répertoires de configuration OpenDKIM..."
}

msg_step4_signing_table_ok() {
  echo "✅ signing.table configuré."
}

msg_step4_key_table_ok() {
  echo "✅ key.table configuré."
}

msg_step4_trusted_hosts_ok() {
  echo "✅ trusted.hosts configuré."
}

msg_step4_files_created() {
  echo "✅ Fichiers signing.table, key.table et trusted.hosts créés et configurés."
}


#--------------------------------------------#   
# ✅ Partie 5 – Génération des clés DKIM     #
#--------------------------------------------#

msg_step5_title() {
  echo "🔐 Étape 5 - Génération des clés privées/public DKIM pour ${DOMAIN}"
}

msg_step5_existing_key() {
  echo "⚠️ Une clé DKIM existe déjà pour ce domaine. Aucune nouvelle clé générée."
}

msg_step5_key_generating() {
  echo "🔐 Génération de la paire de clés DKIM (2048 bits) pour ${DOMAIN}..."
}

msg_step5_key_success() {
  echo "✅ Paire de clés générée avec succès pour ${DOMAIN}"
}

#---------------------------------------------------#
# ✅ Partie 6 – Publication de la clé publique DKIM #
#---------------------------------------------------#

msg_step6_title() {
  echo "📘 Étape 6 - Publication de la clé publique DKIM dans le DNS"
}

msg_step6_dkim_raw_display() {
  echo -e "\n\n📜 Contenu brut de la clé (format OpenDKIM) :"
}

msg_step6_dkim_cleaned_intro() {
  echo -e "\n\n🔧 Préparation de la clé pour le DNS (version nettoyée, 5 espaces entre les segments) :"
}

msg_step6_dns_insert() {
  echo -e "\n\n🧾 À insérer dans le champ TXT de : default._domainkey.${DOMAIN}"
}

msg_step6_dkim_pause_copy() {
  echo -e "\n\n⏸️  Appuie sur Entrée une fois la clé copiée dans le DNS chez ton registrar..."
}

msg_step6_dkim_exported() {
  echo -e "\n\n✅ Clé publique DKIM exportée dans : $EXPORT_KEY_FILE"
}

msg_step6_success() {
  echo -e "\n\n🎉 Félicitations ! SPF et DKIM sont maintenant configurés pour le domaine ${DOMAIN}."
}

#---------------------------------------------#
# ✅ Partie 7 – Test avec opendkim-testkey    #
#---------------------------------------------#

msg_step7_title() {
  echo "🧪 Étape 7 - Vérification de la clé DKIM publiée dans le DNS"
}

msg_step7_checking() {
  echo "🔍 Vérification avec opendkim-testkey pour : default._domainkey.${DOMAIN}"
}

msg_step7_timeout_error() {
  echo "⚠️ Erreur : query timed out détectée"
}

msg_step7_fixing_anchor() {
  echo "🔧 Correction automatique : commentaire de la ligne TrustAnchorFile"
}

msg_step7_opendkim_restarted() {
  echo "✅ Service OpenDKIM redémarré après correction"
}

msg_step7_no_anchor() {
  echo "ℹ️ Ligne TrustAnchorFile absente, aucune action nécessaire"
}

msg_step7_valid_key() {
  echo "✅ DKIM : clé valide et bien publiée pour default._domainkey.${DOMAIN}"
}

msg_step7_success() {
  echo "✅ Étape 7 terminée : test de clé DKIM réussi pour ${DOMAIN}."
}

#---------------------------------------------#
# ✅ Partie 8 – Connexion OpenDKIM ↔️ Postfix  #
#---------------------------------------------#

msg_step8_title() {
  echo -e "\n📘 Étape 8 - Connexion de OpenDKIM à Postfix via socket Unix"
}

msg_step8_conf_opendkim() {
  echo "📝 Modification de /etc/opendkim.conf"
}

msg_step8_conf_default() {
  echo "📝 Modification de /etc/default/opendkim"
}

msg_step8_conf_postfix() {
  echo "📝 Modification de /etc/postfix/main.cf"
}

msg_step8_socket_replaced() {
  echo "🔧 Ligne Socket existante détectée, on la commente et on ajoute la nouvelle"
}

msg_step8_socket_added() {
  echo "➕ Ligne Socket absente, ajoutée à la fin du fichier"
}

msg_step8_postfix_milter() {
  echo -e "# 📬 OpenDKIM Milter"
}

msg_step8_services_restart() {
  echo "🔄 Redémarrage de OpenDKIM et Postfix"
}

msg_step8_success() {
  echo "✅ Étape 8 terminée : OpenDKIM connecté à Postfix via socket Unix."
}


#-------------------------------------------------------#
# ✅ Partie 9 – Vérification finale avec swaks + openssl #
#-------------------------------------------------------#

msg_step9_title() {
  echo -e "\n📘 Étape 9 - Vérification complète du serveur mail"
}

msg_step9_start() {
  echo "📮 Étape 9 - Test complet du serveur mail"
}

msg_step9_install_swaks() {
  echo "📦 Installation du paquet swaks pour les tests SMTP..."
}

msg_step9_check_auth() {
  echo "✉️ Envoi d’un email de test vers check-auth@verifier.port25.com"
}

msg_step9_wait_result() {
  echo "📥 Attends quelques secondes, puis vérifie que SPF / DKIM / DMARC passent correctement (PASS)"
}

msg_step9_prompt_continue() {
  echo "✔️ Appuie sur Entrée une fois que tu as vu le résultat..."
}

msg_step9_ask_mailtester() {
  echo "Souhaitez-vous faire un test Mail-tester ? (O/N) : "
}

msg_step9_prompt_mailtester() {
  echo "➡️ Adresse de test mail-tester (copiée depuis l’interface) : "
}

msg_step9_sending_mailtester() {
  echo "✉️ Envoi d’un email vers Mail-tester..."
}

msg_step9_mailtester_link() {
  echo "🔗 Vérifie ton score sur : https://www.mail-tester.com"
}

msg_step9_tls_check() {
  echo -e "\n🔐 Test STARTTLS sur le port 587 avec OpenSSL"
}

msg_step9_success() {
  echo -e "\n✅ Étape 9 terminée. Vous pouvez valider les résultats affichés."
}


# === MESSAGES POUR REVERT / RESTAURATION ===

msg_revert_intro() {
  echo -e "\n\n🔁 Script de restauration SPF & DKIM – Annulation complète"
}

msg_revert_warning() {
  echo -e "\n\n⚠️ Attention : tous les fichiers, paquets et configurations liés à DKIM/SPF ont été supprimés."
}

msg_revert_done() {
  echo -e "\n\n✅ Restauration terminée. La configuration précédente a été supprimée."
}

#---------------------------------------------#
# ✅ Dossier maintenance(restauration)        #
#---------------------------------------------#
# 

# === QUESTION FACULTATIVE ===

ask_optional_cleanup() {
  echo -e "\n\n🗂️ Suppression des exports et sauvegardes (facultatif)"
  echo -e "\n\n"
  read -rp "Souhaitez-vous supprimer les dossiers de backup et export ? (o/N) : " CLEAN_CHOICE
  if [[ "$CLEAN_CHOICE" =~ ^[Oo]$ ]]; then
    return 0  # Oui
  else
    echo "⏭️ Suppression ignorée."
    return 1  # Non ou vide
  fi
}
echo -e "\n\n"


# Utilisé pour : Chapitre 5 – 

# Utilisé pour : Chapitre 6 – 

# Utilisé pour : Chapitre 7 – 

# Utilisé pour : Chapitre 8 – 

# Utilisé pour : Chapitre 9 – 

# Utilisé pour : Chapitre 10 – 

# Utilisé pour : Chapitre 11 – 

# Utilisé pour : Chapitre 12 – 

# Utilisé pour : Chapitre 13 – 

# Utilisé pour : Chapitre 14 – 

# Utilisé pour : Chapitre 15 – 

# Utilisé pour : Chapitre 16 – 
