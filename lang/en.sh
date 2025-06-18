#!/bin/bash

# 🇫🇷 Language file - French

# ==================================================================
# ✅ GENERAL MESSAGES - All chapters
# ==================================================================

# Local warnings
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

sg_lang="🌍 Selected language: English"
msg_select_language="🌐 Choose your language:"
msg_select_english="1) French"
msg_select_french="2) English"
msg_invalid_choice="❌ Invalid choice. Defaulting to English."

# Common user prompts
msg_prompt_domain="Enter your domain (e.g., example.com)"
msg_prompt_mail_fqdn="Enter your mail server FQDN (e.g., mail.domain.tld)"
msg_prompt_certbot_email="📧 Enter your email address for Let's Encrypt (Certbot)"
msg_prompt_mail_from="Sender email address"
msg_prompt_mail_dest="Destination email address (test)"
msg_prompt_confirm="Do you want to continue? (y/n)"



# 🔁 General status
msg_starting="🚀 Starting the script..."
msg_update_system="🔄 Performing a full system update..."
msg_done="✅ Done"
msg_error="❌ An error occurred"
msg_success="✅ Completed"

# ✅ Dynamic end-of-step message
msg_step_success_prefix="✅ Step"
msg_step_success_suffix="completed successfully."

# 🔐 UFW firewall messages
msg_ufw_not_installed="UFW is not installed. No active firewall detected."
msg_check_ufw="🔎 Checking the UFW firewall status..."
msg_active_ufw="✅ UFW is already enabled."
msg_inactive_ufw="❌ UFW is not enabled on this server."
msg_enable_ufw="Would you like to enable UFW to secure your server?"
msg_enable_ufw_activate="🔐 Enabling UFW firewall..."
msg_ufw_activated="✅ UFW has been enabled successfully."
msg_ufw_keep_enabled="UFW is active. Do you want to keep it enabled?"
msg_ufw_disabling="Disabling UFW..."
msg_ufw_disabled="UFW has been disabled."
msg_ufw_left_disabled="UFW left disabled."
msg_open_ports="🌐 Opening necessary ports in the firewall..."
msg_open_ports_complete="✅ Required ports have been opened."
msg_press_enter="Press [Enter] to continue..."

# 🌐 Apache + Certbot (shared)
msg_create_apache_vhost="🛠️ Creating Apache virtualhost..."
msg_enable_apache_vhost="✅ Apache site enabled and default disabled..."
msg_run_certbot="🔐 Running Certbot to obtain Let's Encrypt TLS certificate..."

# 🔁 GENERAL MESSAGES - Restore / Uninstall
msg_revert_intro() {
  echo -e "SPF & DKIM restore script - Complete cancellation"
}

msg_revert_warning() {
  echo -e "\n\n⚠️ Warning: all DKIM/SPF-related files, packages and configurations have been deleted."
}

msg_revert_done() {
  echo -e "Restore complete. The previous configuration has been deleted."
}

# 🧹 Optional cleanup (exports / backups)
ask_optional_cleanup() {
  echo -e "\nn🗂️ Deletion of exports and backups (optional)"
  echo -e "\n"
  read -rp "Would you like to delete backup and export folders (y/N): " CLEAN_CHOICE
  if [[ \"$CLEAN_CHOICE\" =~ ^[Oo]$ ]]; then
    return 0
  else
    echo \"⏭️ Deletion ignored.\"
    return 1
  fi
}

# Common states
msg_starting="🚀 Starting script..."
msg_done="✅ Finished"
msg_error="❌ An error has occurred"

# ------------------------------------------------------------------
# 📘            ------- introduction -------
# ------------------------------------------------------------------

# === INTRO BANNER ===
msg_banner_chap1() {
  echo "📘 Postfix Configuration Script – Chapter 01"
}

msg_intro_chap1() {
  echo "🚀 This script installs and tests a basic Postfix server on Ubuntu."
}

msg_steps_chap1() {
  echo "🧾 This script will execute all required steps to configure Postfix on Ubuntu (14 steps included in this chapter)."
}

msg_steps_chap1_list() {
  echo -e "
1️⃣  Initialize the main domain
2️⃣  Add the FQDN to /etc/hosts
3️⃣  Verify the system hostname
4️⃣  Check DNS records
5️⃣  Update the system and install Postfix
6️⃣  Check the firewall status
7️⃣  Test outbound connection on port 25
8️⃣  Send a test email using sendmail
9️⃣  Install Mailutils and test local delivery
🔟  Set the maximum allowed email size
1️⃣1️⃣  Define 'myhostname' in Postfix
1️⃣2️⃣  Create required mail aliases
1️⃣3️⃣  Configure IP protocols (IPv4 / IPv6)
1️⃣4️⃣  Update Postfix without overwriting configuration
"
}


# ------------------------------------------------------------------
# 📘 Step 1 – Initializing the primary domain
# ------------------------------------------------------------------
msg_step1_title()  { echo “📘 Step 1 – Defining the primary domain”; }
msg_step1_start()  { echo “🔧 Initializing the primary domain...”; }
msg_step1_prompt="Primary domain name"
msg_step1_ok="Primary domain defined"

# ------------------------------------------------------------------
# 🖋️ Step 2 – Adding the FQDN to the /etc/hosts file
# ------------------------------------------------------------------
msg_step2_title()  { echo “📘 Step 2 – Adding the FQDN to /etc/hosts”; }
msg_step2_start()  { echo “🖋️ Adding the FQDN entry to the hosts file...”; }
msg_step2_exists="Entry already present in /etc/hosts"
msg_step2_added="Entry added"

# ------------------------------------------------------------------
# 🖥️ Step 3 – Checking the system hostname
# ------------------------------------------------------------------

msg_step3_title() { echo "📘 Step 3 - Verify system hostname"; }
msg_step3_start() { echo "🔍 Verify and adjust hostname..."; }
msg_step3_current="Current hostname"
msg_step3_prompt="New hostname (leave empty to keep)"
msg_step3_set="Host name updated"
msg_step3_ok="Host name already correct"
msg_step3_hostname_invalid="⚠️ The hostname entered contains invalid characters."
msg_step3_hostname_allowed="❌ Only lowercase characters, digits, periods (.) and dashes (-) are allowed."
msg_step3_hostname_kept="⏭️ Host name kept unchanged"


# ------------------------------------------------------------------
# 🌐 Step 4 – Checking DNS records
# ------------------------------------------------------------------

msg_step4_title()  { echo "📘 Step 4 – Checking DNS records"; }
msg_step4_start()  { echo "🔍 Checking DNS..."; }

msg_step4_dns_reminder="Add the following DNS records to your registrar"
msg_step4_dns_examples="Examples of records"

msg_step4_mx_example()     { echo "🔹 MX RECORD\n   @      300 IN MX 10 mail.${DOMAIN}"; }
msg_step4_spf_example()    { echo "🔹 SPF RECORD\n   @      300 IN TXT \"v=spf1 mx -all\""; }
msg_step4_dmarc_example()  { echo "🔹 DMARC RECORD\n   _dmarc 300 IN TXT \"v=DMARC1; p=none; rua=mailto:dmarc@${DOMAIN}; pct=100\""; }

msg_step4_wait_user()  { echo "⏸️  Press [Enter] once you have added the DNS records to your registrar..."; }

msg_step4_testing_dns="Checking DNS propagation..."

msg_step4_mx_title="🔍 MX record for"
msg_step4_spf_title="🔍 SPF record for"
msg_step4_dmarc_title="🔍 DMARC record for"

msg_step4_spf_missing="⚠️  No SPF record found."
msg_step4_dmarc_missing="⚠️  No DMARC record found."

msg_step4_continue="⏸️  Press [Enter] to continue..."
msg_step4_success="✅ DNS records verified"


# ------------------------------------------------------------------
# 🧰 Step 5 – System update and Postfix installation
# ------------------------------------------------------------------

msg_step5_title()        { echo "📘 Step 5 – System update and Postfix installation"; }
msg_step5_start()        { echo "🔧 Starting system update and Postfix installation..."; }
msg_step5_update()       { echo "Updating packages..."; }
msg_step5_config_info()  { echo "During installation, follow the on-screen instructions:"; }
msg_step5_config_1()     { echo "   ➤ 1. Select: 'Internet Site'"; }
msg_step5_config_2()     { echo "   ➤ 2. Enter your main domain name"; }
msg_step5_installing()   { echo "Installing Postfix..."; }
msg_step5_check_version() { echo "Postfix version installed:"; }
msg_step5_check_port()   { echo "Checking that port 25 is listening:"; }
msg_step5_port_warning() { echo "❌ Postfix does not appear to be listening on port 25."; }
msg_step5_check_binaries() { echo "Postfix binaries found in /usr/sbin/:"; }
msg_step5_success()      { echo "✅ Postfix successfully installed and verified."; }


# ------------------------------------------------------------------
# 🔥 Step 6 – Checking the firewall status
# ------------------------------------------------------------------

msg_step6_title()              { echo “🔥 Step 6 – Checking the firewall status (UFW)”; }
msg_step6_success()            { echo “✅ Firewall checked (UFW)”; }

# ------------------------------------------------------------------
# 📘 Step 7 – Check outgoing connection to port 25 (SMTP)
# ------------------------------------------------------------------

msg_step7_title()          { echo "📘 Step 7 – Outgoing connection test to port 25 (SMTP)"; }
msg_step7_start()          { echo "🔍 Checking if outbound port 25 is open (to smtp.gmail.com)"; }
msg_step7_smtp_test()      { echo "Testing outbound connection to smtp.gmail.com on port 25..."; }
msg_step7_explanation()    { echo "(This test checks if your ISP or host blocks outbound port 25)"; }
msg_step7_telnet_missing() { echo "Telnet is not installed. Installing..."; }
msg_step7_success()        { echo "✅ SMTP test completed"; }

# ------------------------------------------------------------------
# 📘 Step 8 – Sending a test email with Postfix (sendmail)
# ------------------------------------------------------------------

msg_step8_title()          { echo "📘 Step 8 – Sending a test email with Postfix (sendmail)"; }
msg_step8_start()          { echo "🔍 Testing email sending using the sendmail command"; }
msg_step8_test_sendmail()  { echo "Sending a test email using sendmail..."; }
msg_step8_content()        { echo "Content: « test email »"; }
msg_step8_dest()           { echo "Recipient"; }
msg_step8_local_mailbox()  { echo "Local mailbox for each user"; }
msg_step8_log_hint()       { echo "To check Postfix logs, consult:"; }
msg_step8_verification_ok="Email successfully delivered (status=sent found in logs)."
msg_step8_verification_fail="No status=sent found. Please check your configuration or the logs."
msg_step8_success()        { echo "✅ Email sent successfully"; }


# ------------------------------------------------------------------
# 📘 Step 9 – Installing Mailutils and testing local sending
# ------------------------------------------------------------------

msg_step9_title()           { echo "📘 Step 9 – Mailutils installation and local email test"; }
msg_step9_start()           { echo "📦 Installing mailutils and running local test..."; }
msg_step9_installing="Installing mailutils (command-line email client)..."
msg_step9_sending="Sending a local email using Mailutils..."
msg_step9_subject_display="Email subject"
msg_step9_mail_subject="✅ Chapter 1 Test"
msg_step9_mail_body="✅ Postfix is working – Chapter 1 test\n\nHost: $(hostname)"
msg_step9_ask_received="Did you receive the test email?"
msg_step9_received="the email was successfully received ✅"
msg_step9_not_received="the email was not received. We will check again at the end of the chapter."
msg_step9_success()         { echo "✅ Mailutils test completed"; }

# ------------------------------------------------------------------
# 📘 Step 10 – Set the maximum email size (message_size_limit)
# ------------------------------------------------------------------

msg_step10_title()       { echo "📘 Step 10 – Set the maximum email size (message_size_limit)"; }
msg_step10_start()       { echo "🔧 Configuring the maximum allowed email size..."; }
msg_step10_current="Current allowed message size"
msg_step10_box_limit="Current mailbox size limit (mailbox_size_limit)"
msg_step10_warn_box="⚠️ WARNING: The message size exceeds the allowed mailbox size."
msg_step10_confirm_apply="Do you still want to apply this value?"
msg_step10_abort="Change aborted."
msg_step10_ask_size="New maximum size for an email (in bytes)"
msg_step10_applied="Maximum size updated"
msg_step10_default="Value kept"
msg_step10_success()     { echo "✅ Step 10 completed."; }

# ------------------------------------------------------------------
# 📘 Step 11 – Set myhostname in Postfix (recommended FQDN)
# ------------------------------------------------------------------

msg_step11_title()          { echo "📘 Step 11 – Set myhostname in Postfix (recommended FQDN)"; }
msg_step11_current()        { echo "Current name (myhostname in Postfix)"; }
msg_step11_prompt()         { echo "Enter the full FQDN hostname for the mail server (myhostname)"; }
msg_step11_warn_apex()      { echo "Warning: you are using the root domain. This is not recommended."; }
msg_step11_suggest_fqdn()   { echo "Use a subdomain FQDN like mail.domain.tld."; }
msg_step11_applied()        { echo "FQDN successfully applied in the Postfix configuration"; }
msg_step11_success()        { echo "✅ Step 11 completed."; }
msg_step11_comment_header="👇 Declared in Chapter 1 script – Postfix configuration"

# ------------------------------------------------------------------
# 📘 Step 12 – Create required mail aliases (RFC 2142)
# ------------------------------------------------------------------

msg_step12_title()           { echo "📘 Step 12 – Create required mail aliases (RFC 2142)"; }
msg_step12_prompt_alias()    { echo "Which user should receive system emails?"; }
msg_step12_add_postmaster()  { echo "➕ Alias added: postmaster → root"; }
msg_step12_root_modified()   { echo "✅ Alias modified: root →"; }
msg_step12_no_change()       { echo "ℹ️ No custom alias provided. Root alias unchanged."; }
msg_step12_newaliases()      { echo "✅ Alias table updated successfully."; }
msg_step12_success()         { echo "✅ Step 12 completed."; }


# ------------------------------------------------------------------
# 📘 Step 13 – Configure IP protocols (IPv4 / IPv6)
# ------------------------------------------------------------------

msg_step13_title()         { echo "📘 Step 13 – Configure IP protocols (IPv4 / IPv6)"; }
msg_step13_current()       { echo "Currently configured IP protocol(s) (inet_protocols)"; }
msg_step13_explain()       { echo "Choose which IP protocols Postfix should use:"; }
msg_step13_prompt_choice() { echo "Your choice (1=IPv4, 2=IPv6, 3=both)"; }
msg_step13_keep_default="keep default"
msg_step13_comment="IP protocol set by Chapter 1 script"
msg_step13_set_ipv4="✅ inet_protocols set to ipv4"
msg_step13_set_ipv6="✅ inet_protocols set to ipv6"
msg_step13_set_all="✅ inet_protocols set to all"
msg_step13_keep="ℹ️ No change made. Current value kept"
msg_step13_restart="🔄 Restarting Postfix after inet_protocols change..."
msg_step13_success()       { echo "✅ Step 13 completed."; }
msg_press_enter_word="Enter"


# ------------------------------------------------------------------
# 📘 Step 14 – Postfix update (preserve configuration)
# ------------------------------------------------------------------

msg_step14_title()         { echo "📘 Step 14 – Postfix update (preserve configuration)"; }
msg_step14_update_notice() { echo "Updating Postfix and available packages..."; }
msg_step14_upgrade_tip1()  { echo "🧠 When prompted during the update, choose:"; }
msg_step14_upgrade_tip2()  { echo "➤ ‘❌ None (No configuration)’ to keep your current files."; }
msg_step14_success()       { echo "✅ Step 14 completed."; }

# ------------------------------------------------------------------
# 📘 Step 15 – Backup main.cf (non-destructive)
# ------------------------------------------------------------------
msg_step15_title() { echo "📘 Step 15 – Backup of main.cf (non-destructive copy)"; }
msg_step15_success() { echo "✅ main.cf file successfully backed up."; }

# ------------------------------------------------------------------
# 📘 Step 16 – Restart Postfix
# ------------------------------------------------------------------
msg_step16_title() { echo "📘 Step 16 – Restarting the Postfix service"; }
msg_step16_success() { echo "✅ Postfix restarted successfully."; }


# ==========================================================
# 🧹 Uninstall script – Chapter 1 (Basic Postfix)
# 📦 Removing changes made in Chapter 1
# ==========================================================
msg_uninstall_intro="🧹 This script cleanly removes the configuration from Chapter 1."
msg_uninstall_backup="Backing up files before removal..."
msg_uninstall_clean_hosts="Cleaning 127.0.1.1 line from /etc/hosts..."
msg_uninstall_clean_maincf="Cleaning main.cf (myhostname, inet_protocols, message_size_limit)..."
msg_uninstall_clean_aliases="Removing aliases for postmaster: and root:..."
msg_uninstall_ask_remove_postfix="Do you want to completely remove Postfix?"
msg_prompt_yes_no_default="Yes/No (default: No)"
msg_uninstall_removing="Removing Postfix..."
msg_uninstall_removed="Postfix was successfully removed."
msg_uninstall_not_installed="Postfix is not installed. Nothing to do."
msg_uninstall_skipped="Postfix removal skipped."
msg_uninstall_success="✅ End of Chapter 1 uninstall script"



# ==================================================================
# 📘 Chapter 02 – Installing Postfix and Dovecot
# ==================================================================

# ------------------------------------------------------------------
# 📘 Chapter 02 - Step 0 –  Introduction
# ------------------------------------------------------------------

msg_step0_banner_chap2="###########################################\n💼 Postfix & Dovecot – Mail Server Setup 💼\n###########################################"

msg_step0_intro_chap2="🎉 Welcome to the secure mail server setup script using Postfix and Dovecot."

msg_steps0_chap2="🧾 This script will perform all the steps required to install Postfix and Dovecot (8 steps in this chapter)."

msg_step0_steps_chap2() {
  echo -e "
🧾 This script will execute the following steps:
1️⃣  Check the UFW firewall status and open necessary ports
2️⃣  Install Certbot and the Apache web server
3️⃣  Create the Apache virtualhost + obtain the Let's Encrypt TLS certificate
4️⃣  Install Postfix and basic configuration
5️⃣  Install Dovecot with Maildir + TLS configuration
6️⃣  Add TLS settings in Postfix
7️⃣  Send a test email with Postfix
8️⃣  Test secure IMAP connection (port 993)
"
}

# ------------------------------------------------------------------
# 📘 Chapter 02 - Step 1 – UFW Firewall and Opening Ports
# ------------------------------------------------------------------

msg_step1_chap2_intro()   { echo "🚀 Starting Step 1 – UFW Firewall Check and Opening Ports."; }

# ------------------------------------------------------------------
# 📘 Chapter 02 - Step 2 – Install Certbot + Apache Plugin
# ------------------------------------------------------------------

msg_step2_chap2_intro()   { echo "🚀 Starting Step 2 – Preparing to obtain a TLS certificate."; }
msg_install_certbot_chap2="🔧 Installing Certbot (Let's Encrypt client)..."
msg_install_apache_plugin_chap2="🧩 Installing Apache server and Certbot plugin for Apache..."

# ------------------------------------------------------------------
# 📘 Chapter 02 - Step 3 – Obtain Let's Encrypt TLS Certificate with Apache
# ------------------------------------------------------------------

msg_step3_chap2_intro()   { echo "🚀 Starting Step 3 – Obtaining TLS certificate with Apache."; }


# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 4: Install Postfix + master.cf config
# ------------------------------------------------------------------

msg_step4_chap2_intro() {
  echo "🚀 Starting Step 4 – Installing Postfix + master.cf config."
}

msg_step4_maincf_done="💾 main.cf backup completed."
msg_step4_mastercf_done="💾 master.cf backup completed."

msg_step4_chap2_mastercf_intro() {
  echo "🔧 Enabling submission (587) and smtps (465) services in master.cf..."
}

msg_step4_chap2_mastercf_added="✅ Submission and SMTPS blocks added to master.cf."
msg_step4_chap2_mastercf_already_present="ℹ️  Submission and SMTPS blocks already present in master.cf."
msg_step4_chap2_mastercf_success="✅ Postfix successfully restarted."

msg_step4_postfix_config_chap2="⚙️  Configuring Postfix with default parameters..."
msg_step4_postfix_config_domain_chap2() {
  echo "⚙️  Configuring Postfix with domain $DOMAIN..."
}

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 5: Installing Dovecot
# ------------------------------------------------------------------

msg_step5_chap2_intro() {
  echo "🚀 Starting Step 5 – Installing Dovecot (IMAP/POP3 server)..."
}

msg_step5_install_dovecot_chap2="📦 Installing Dovecot packages: core, imapd, pop3d..."
msg_step5_check_dovecot_version="🔍 Checking installed Dovecot version..."


# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 6: Enable IMAP/POP3 protocols
# ------------------------------------------------------------------

msg_step6_chap2_intro() {
  echo "🚀 Starting Step 6 – Enabling IMAP and POP3 protocols..."
}

msg_step6_dovecot_bak="💾 Backup of dovecot.conf completed."
msg_step6_enable_protocols="🔧 Enabling IMAP and POP3 protocols in dovecot.conf..."
msg_step6_restart_dovecot="🔄 Restarting Dovecot service..."



# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 7: Maildir format configuration
# ------------------------------------------------------------------

msg_step7_chap2_intro() {
  echo "🚀 Starting Step 7 – Configuring Maildir format in Dovecot..."
}

msg_step7_dovecot_mail_bak_done="💾 File 10-mail.conf copied with .bak_DATE suffix."
msg_step7_config_mail_location="🛠️ Applying maildir:~/Maildir format in 10-mail.conf..."
msg_step7_add_priv_group="➕ Adding mail_privileged_group = mail"
msg_step7_priv_group_already="ℹ️  mail_privileged_group already present in the file."
msg_step7_add_usergroup="👤 Adding user dovecot to mail group..."
msg_step7_restart_dovecot="🔄 Restarting Dovecot service..."

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 8: Configure Dovecot LMTP
# ------------------------------------------------------------------

msg_step8_chap2_intro() {
  echo "🚀 Starting Step 8 – Configuring Dovecot to deliver emails using LMTP."
}

msg_step8_install_lmtpd="📦 Installing dovecot-lmtpd package..."
msg_step8_update_dovecot_conf="🛠️ Editing /etc/dovecot/dovecot.conf to enable LMTP..."
msg_step8_update_master_conf="🛠️ Configuring LMTP service in 10-master.conf..."
msg_step8_update_postfix_maincf="🛠️ Adding LMTP configuration to Postfix (main.cf)..."

msg_step8_done="✅ Step 8 completed: Dovecot will now use LMTP to deliver emails in Maildir format."

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 9: Dovecot Authentication Mechanism
# ------------------------------------------------------------------

msg_step9_chap2_intro() {
  echo "🚀 Starting Step 9 – Configuring Dovecot authentication mechanism..."
}

msg_step9_10auth_done="💾 Backup of 10-auth.conf completed."
msg_step9_dovecot_disable_plaintext="🔐 Enabling protection against plaintext auth (disable_plaintext_auth = yes)..."
msg_step9_dovecot_username_format="👤 Simplifying username format (auth_username_format = %n)..."
msg_step9_dovecot_mechanisms="🔧 Adding LOGIN auth mechanism (auth_mechanisms = plain login)..."

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 10: Enable TLS Encryption in Dovecot
# ------------------------------------------------------------------

msg_step10_chap2_intro() {
  echo "🚀 Starting Step 10 – Configuring TLS/SSL in Dovecot..."
}
msg_step10_chap2_tls_config="🔐 Configuring Dovecot TLS..."
msg_step10_chap2_tls_domain() {
  echo "🔧 Secured domain: $DOMAIN"
}
msg_step10_chap2_tls_backup_done="💾 Backup of 10-ssl.conf completed."

# ------------------------------------------------------------------
# 📘 Chapter 02 – Disable OpenSSL's FIPS provider (Ubuntu 22.04)
# ------------------------------------------------------------------
# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 11: Disable FIPS Provider in OpenSSL
# ------------------------------------------------------------------

msg_step11_chap2_intro="🚫 Step 11 – Disabling FIPS provider in OpenSSL (Ubuntu 22.04)..."
msg_step11_chap2_openssl_backup_done="💾 openssl.cnf backup completed."
msg_step11_chap2_fips_disabled="✅ FIPS provider disabled in OpenSSL."
msg_step11_chap2_already_commented="ℹ️ FIPS line was already commented."
msg_step11_chap2_openssl_check="🔎 Checking OpenSSL configuration after modification..."

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 12: SASL Authentication (SMTP AUTH)
# ------------------------------------------------------------------

msg_step12_chap2_intro="🔐 Configuring SASL authentication via Dovecot for Postfix..."

msg_step12_chap2_backup_done="💾 Backup of 10-master.conf completed."
msg_step12_chap2_already_configured="ℹ️  SASL block already present in 10-master.conf, no changes made."
msg_step12_chap2_sasl_auth_configured="✅ SASL block added to 10-master.conf for Postfix."


# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 13: Auto-Renew TLS Certificate
# ------------------------------------------------------------------

msg_step13_chap2_dryrun_check="🧪 Testing auto-renewal with: certbot renew --dry-run"
msg_step13_chap2_dryrun_success="✅ Dry-run successful: renewal works correctly."
msg_step13_chap2_dryrun_failed="❌ Dry-run test failed. Please check the log file."
msg_step13_chap2_log_hint="Log file location"

# ------------------------------------------------------------------
# 📘 Chapter 02 – Step 14: Dovecot Automatic Restart
# ------------------------------------------------------------------

msg_step14_chap2_intro="🔄 Setting up Dovecot automatic restart with systemd..."
msg_step14_chap2_backup_done="💾 Existing restart.conf file backed up."
msg_step14_chap2_create_file="📝 Writing /etc/systemd/system/dovecot.service.d/restart.conf..."
msg_step14_chap2_reload_systemd="🔁 systemd reload completed."


# ==========================================================
# 🧹 Chapitre 02 - Script de désinstallation
# 📦 pontarlier-informatique - osnetworking
# ==========================================================

# ============================================================
# 🧼 Chapitre 02 - Étape 1 - Restauration des fichiers de configuration
# ============================================================
msg_step1_restore_configs="Restauration des fichiers de configuration modifiés..."

# ============================================================
# Chapitre 02 - Étape 2 - Suppression de la configuration de redémarrage automatique Dovecot
# ============================================================
msg_step2_remove_restart="Suppression de la configuration de redémarrage automatique Dovecot..."

# ============================================================
# 🧼 Chapitre 02 - Étape 3 - Suppression de Certbot, Apache et du vhost associé
# ============================================================
msg_step3_apache_certbot="Suppression de Certbot, Apache et du vhost associé..."

# ============================================================
# 🧼 Chapitre 02 - Suppression des paquets Dovecot (core, imapd, pop3d, lmtpd)
# ============================================================
msg_step4_remove_dovecot="Suppression des paquets Dovecot (core, imapd, pop3d, lmtpd)..."

# ============================================================
# 🧼 Chapitre 02 - Étape 5 - Nettoyage Postfix (TLS)
# ============================================================
msg_step5_restart="Redémarrage de Postfix et Dovecot..."

# ============================================================
# ✅ Chapitre 02 - Fin de désinstallation
# ============================================================
msg_uninstall_success="✅ Désinstallation complète du Chapitre 2 effectuée avec succès."




# ============================================================
# 📘 MESSAGES – Chapter 3: PostfixAdmin + Virtual Accounts
# ============================================================

msg_banner_chap3="📘 Chapter 3 – PostfixAdmin and Virtual Mailboxes"
msg_intro_chap3=“📦 This script configures PostfixAdmin, virtual mailboxes, and the database for multi-domain management.”
msg_steps_chap3="📜 Steps:
1. Install MariaDB and create the database.
2. Configure Postfix for virtual accounts.
3. Configure Dovecot with SQL authentication.
4. Install PostfixAdmin.
5. Create a domain and a user."

msg_install_mariadb_chap3="📦 Installing MariaDB..."
msg_create_db_chap3="🗃️ Creating the database and tables..."
msg_config_postfix_sql_chap3=“⚙️ Configuring Postfix SQL...”
msg_config_dovecot_sql_chap3="⚙️ Configuring Dovecot SQL..."
msg_install_postfixadmin_chap3="📦 Installing PostfixAdmin..."
msg_add_domain_user_chap3=“➕ Adding the domain and an email account...”
msg_success_chap3="🎉 Chapter 3 successfully completed!"

# ============================================================
# 📘 MESSAGES – Chapter 4: SPF & DKIM
# ============================================================

msg_banner_chap4=“📘 Chapter 4 – SPF & DKIM Configuration”
msg_intro_chap4="🔐 This script configures SPF, installs OpenDKIM, and signs your emails automatically."
msg_steps_chap4="📜 Steps:
1. Create the SPF DNS entry.
2. Install postfix-policyd-spf-python.
3. Install OpenDKIM.
4. Create public/private keys.
5. Add signature tables.
6. Test the DKIM signature."

# (... add here all msg_stepX_chap4 used in the dkim script)

msg_success_chap4=“🎉 SPF & DKIM successfully configured!”

# ============================================================
# 📘 Next chapters (placeholders to be filled in as you go)
# ============================================================

# msg_intro_chap5="..."
# msg_steps_chap5="..."
# msg_intro_chap6="..."
# msg_intro_chap7="..."
# ...