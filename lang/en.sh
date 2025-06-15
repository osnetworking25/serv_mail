#!/bin/bash


# 🇬🇧 Language file – English

# ✅ 🌍 Silence locale warnings
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

# Introduction message (called after language selection)
msg_lang() {
  echo -e "\n📘 Welcome to the Chapter 4 – SPF & DKIM setup script"
  echo "ℹ️  This script will guide you step by step to configure SPF, DKIM, and DMARC for your mail server."
}
# Used for : Chapter 1 -


# Used for : # Chapter 2 - Postfix and Dovecot Installation

# Introduction and steps
msg_intro_chap2="🎉 Welcome to the secure email server setup script with Postfix and Dovecot."
msg_steps_chap2="📜 This script will follow the steps:
1. Check the status of **UFW** (firewall) and enable it if necessary.
2. Open the necessary ports for email handling.
3. Install **Postfix** for outgoing email management (SMTP).
4. Install **Dovecot** for incoming email management (IMAP/POP3).
5. Enable **TLS** encryption to secure communications.
6. Run tests to verify the correct configuration of services."

# Messages for UFW activation and ports
msg_select_language_chap2="🌐 Choose your language:"
msg_select_english_chap2="1) Français"
msg_select_french_chap2="2) English"
msg_prompt_domain_chap2="Enter your domain (e.g., example.com)"
msg_prompt_mail_fqdn_chap2="Enter your mail server FQDN (e.g., mail.${DOMAIN})"
msg_banner_chap2="###########################################\n💼 Postfix & Dovecot – Mail Server Setup 💼\n###########################################"

# Status messages for UFW and opening ports
msg_active_ufw_chap2="✅ UFW is already active."
msg_inactive_ufw_chap2="❌ UFW is not active on this server."
msg_enable_ufw_chap2="Would you like to enable UFW to secure your server? (y/n)"
msg_open_ports_chap2="🌐 Opening necessary ports in the firewall..."
msg_open_ports_complete_chap2="✅ Ports have been successfully opened."

# Confirmation messages for installation and tests
msg_install_postfix_chap2="🌐 Installing Postfix..."
msg_install_dovecot_chap2="🌐 Installing Dovecot..."
msg_test_email_chap2="🌐 Testing email sending via Postfix. You will be asked to enter the **subject** and **description** of the email."
msg_prompt_subject="Please enter the subject of the email"
msg_prompt_description="Please enter the description of the email"
msg_test_imap_chap2="🌐 Testing IMAP connection via Dovecot..."
msg_restart_services_chap2="🌐 Restarting Postfix and Dovecot..."
msg_success_chap2="🎉 Mail server setup completed successfully!"

# Messages for configuration test steps
msg_config_test_postfix_chap2="🌐 Verifying Postfix configuration..."
msg_config_test_dovecot_chap2="🌐 Verifying Dovecot configuration..."

# Additional messages for missing steps
msg_check_ufw_chap2="🌐 Checking UFW (firewall) status..."
msg_postfix_config_chap2="Configuring Postfix with domain $DOMAIN..."
msg_dovecot_maildir_config_chap2="Configuring Dovecot for Maildir..."
msg_dovecot_tls_config_chap2="Configuring Dovecot for TLS..."





# Used for : Chapter 3 -


# Used for : Chapter 4 - SPF & DKIM (installation) Script folder

# ✅ === MESSAGES FOR INSTALLATION ===

msg_banner() {
  echo -e "\n\n 📘 SPF & DKIM Configuration Script - Chapter 4"
}

msg_intro() {
  echo "📬 SPF & DKIM setup script based on LinuxBabe (dynamic adapted version)"
  echo "📚 Steps:"
  echo "  1. SPF DNS record"
  echo "  2. Install postfix-policyd-spf-python"
  echo "  3. Install OpenDKIM"
  echo "  4. Create signing/key/trusted tables"
  echo "  5. Generate DKIM key pair"
  echo "  6. Publish DKIM public key in DNS"
  echo "  7. Test DKIM key with opendkim-testkey"
  echo "  8. Connect OpenDKIM ↔️ Postfix via Unix socket"
  echo "  9. Final SPF & DKIM verification with swaks/dig"
}

msg_domain_request() {
  echo -n "🌐 Main domain name (e.g. domain.tld): "
}

msg_mailfrom_request() {
  echo -n "📧 Email address used for tests (e.g. postmaster@${DOMAIN}): "
}

msg_maildest_request() {
  echo -n "📨 Destination address for testing (e.g. Gmail, Outlook): "
}

msg_fqdn_request() {
  echo -n "🌐 FQDN of the mail server (e.g. mail.${DOMAIN}): "
}

# ✅ === PART 1 – SPF Record ===

msg_step1_title() {
  echo -e "\n📘 Step 1 - SPF DNS Record"
}

msg_step1_instruction() {
  echo "Please add the following TXT record in your DNS zone for domain ${DOMAIN}:"
  echo
  echo "   Name  : @"
  echo "   Type  : TXT"
  echo "   Value : v=spf1 mx ~all"
  echo
  echo "💡 This record allows only the MX servers of ${DOMAIN} to send mail."
  echo "🕒 Wait for DNS propagation before continuing."
}

msg_step1_continue_prompt() {
  echo -n "✅ Press Enter once the SPF record is added and propagated..."
}

msg_step1_dig_check() {
  echo "🔍 Checking DNS with dig..."
}

msg_step1_confirm_prompt() {
  echo -n "👁️ Did you visually confirm the SPF record? (Y/N): "
}

msg_step1_confirmed() {
  echo "✅ SPF record confirmed by user."
}

msg_step1_not_confirmed() {
  echo "⚠️ Step 1 not validated. You can repeat this step later."
}

msg_step1_success() {
  echo -e "\n\n✅ SPF record verified. Step 1 completed successfully."
}

# ✅ === PART 2 – SPF Agent ===

msg_step2_title() {
  echo -e "\n\n📘 Step 2 - Install postfix-policyd-spf-python"
}

msg_step2_check_installed() {
  echo -e "\n\n🔍 Checking if the package is already installed..."
}

msg_step2_already_installed() {
  echo -e "\n\n📦 Package postfix-policyd-spf-python is already installed."
}

msg_step2_installing() {
  echo -e "\n\n📥 Installing required package..."
}

msg_step2_success() {
  echo -e "\n\n✅ SPF Policy Agent installed successfully."
}

msg_step2_failure() {
  echo -e "\n\n❌ Failed to install postfix-policyd-spf-python."
}

# ✅ === PART 3 – Install OpenDKIM ===

msg_step3_title() {
  echo -e "\n📘 Step 3 - Installing OpenDKIM"
}

msg_step3_start() {
  echo "🔧 Creating basic folders and files for OpenDKIM"
}

msg_step3_success() {
  echo "✅ Step 3 completed: OpenDKIM installed and config file updated."
}

# ✅ === PART 4 – DKIM Tables ===

msg_step4_title() {
  echo -e "\n📘 Step 4 - Create signing.table, key.table and trusted.hosts"
}

msg_step4_prepare_dirs() {
  echo "📂 Preparing OpenDKIM config directories..."
}

msg_step4_signing_table_ok() {
  echo "✅ signing.table configured."
}

msg_step4_key_table_ok() {
  echo "✅ key.table configured."
}

msg_step4_trusted_hosts_ok() {
  echo "✅ trusted.hosts configured."
}

msg_step4_files_created() {
  echo "✅ DKIM tables created and configured."
}

# ✅ === PART 5 – DKIM Key Generation ===

msg_step5_title() {
  echo "🔐 Step 5 - Generating DKIM private/public keys for ${DOMAIN}"
}

msg_step5_existing_key() {
  echo "⚠️ A DKIM key already exists for this domain. No new key generated."
}

msg_step5_key_generating() {
  echo "🔐 Generating DKIM key pair (2048 bits) for ${DOMAIN}..."
}

msg_step5_key_success() {
  echo "✅ Key pair successfully generated for ${DOMAIN}"
}

# ✅ === PART 6 – DNS Publication ===

msg_step6_title() {
  echo "📘 Step 6 - Publishing DKIM public key in DNS"
}

msg_step6_dkim_raw_display() {
  echo -e "\n\n📜 Raw key content (OpenDKIM format):"
}

msg_step6_dkim_cleaned_intro() {
  echo -e "\n\n🔧 Preparing key for DNS (cleaned, 5 spaces between segments):"
}

msg_step6_dns_insert() {
  echo -e "\n\n🧾 Add the following TXT record to: default._domainkey.${DOMAIN}"
}

msg_step6_dkim_pause_copy() {
  echo -e "\n\n⏸️  Press Enter once you've added the key to your registrar DNS..."
}

msg_step6_dkim_exported() {
  echo -e "\n\n✅ DKIM public key exported to: $EXPORT_KEY_FILE"
}

msg_step6_success() {
  echo -e "\n\n🎉 Congratulations! SPF and DKIM are now configured for ${DOMAIN}."
}

# ✅ === PART 7 – DKIM Test ===

msg_step7_title() {
  echo "🧪 Step 7 - Verifying DKIM key published in DNS"
}

msg_step7_checking() {
  echo "🔍 Checking with opendkim-testkey for: default._domainkey.${DOMAIN}"
}

msg_step7_timeout_error() {
  echo "⚠️ Error: query timed out detected"
}

msg_step7_fixing_anchor() {
  echo "🔧 Automatically commenting TrustAnchorFile line"
}

msg_step7_opendkim_restarted() {
  echo "✅ OpenDKIM service restarted after correction"
}

msg_step7_no_anchor() {
  echo "ℹ️ TrustAnchorFile line not found, no action needed"
}

msg_step7_valid_key() {
  echo "✅ DKIM: valid key successfully published for default._domainkey.${DOMAIN}"
}

msg_step7_success() {
  echo "✅ Step 7 complete: DKIM key test succeeded for ${DOMAIN}."
}

# ✅ === PART 8 – OpenDKIM ↔️ Postfix Socket ===

msg_step8_title() {
  echo -e "\n📘 Step 8 - Connecting OpenDKIM to Postfix via Unix socket"
}

msg_step8_conf_opendkim() {
  echo "📝 Editing /etc/opendkim.conf"
}

msg_step8_conf_default() {
  echo "📝 Editing /etc/default/opendkim"
}

msg_step8_conf_postfix() {
  echo "📝 Editing /etc/postfix/main.cf"
}

msg_step8_socket_replaced() {
  echo "🔧 Existing Socket line found, commented and new line added"
}

msg_step8_socket_added() {
  echo "➕ No Socket line found, added at end of file"
}

msg_step8_postfix_milter() {
  echo -e "# 📬 OpenDKIM Milter"
}

msg_step8_services_restart() {
  echo "🔄 Restarting OpenDKIM and Postfix"
}

msg_step8_success() {
  echo "✅ Step 8 complete: OpenDKIM connected to Postfix via Unix socket."
}

# ✅ === PART 9 – Final Check with swaks/openssl ===

msg_step9_title() {
  echo -e "\n📘 Step 9 - Full verification of mail server"
}

msg_step9_start() {
  echo "📮 Step 9 - Real-world testing of your mail server"
}

msg_step9_install_swaks() {
  echo "📦 Installing swaks package for SMTP tests..."
}

msg_step9_check_auth() {
  echo "✉️ Sending test email to check-auth@verifier.port25.com"
}

msg_step9_wait_result() {
  echo "📥 Wait a few seconds, then confirm SPF / DKIM / DMARC show PASS"
}

msg_step9_prompt_continue() {
  echo "✔️ Press Enter once you've seen the result..."
}

msg_step9_ask_mailtester() {
  echo "Would you like to run a Mail-tester test? (Y/N): "
}

msg_step9_prompt_mailtester() {
  echo "➡️ Mail-tester test address (copy from website): "
}

msg_step9_sending_mailtester() {
  echo "✉️ Sending email to Mail-tester..."
}

msg_step9_mailtester_link() {
  echo "🔗 Check your score at: https://www.mail-tester.com"
}

msg_step9_tls_check() {
  echo -e "\n🔐 Testing STARTTLS on port 587 using OpenSSL"
}

msg_step9_success() {
  echo -e "\n✅ Step 9 complete. You can now validate the displayed results."
}

# ✅ === REVERT MESSAGES ===

msg_revert_intro() {
  echo -e "\n\n🔁 Reverting SPF & DKIM configuration – Full cleanup"
}

msg_revert_warning() {
  echo -e "\n\n⚠️ Warning: all DKIM/SPF related files, packages and configs have been removed."
}

msg_revert_done() {
  echo -e "\n\n✅ Revert complete. Previous configuration removed."
}

ask_optional_cleanup() {
  echo -e "\n\n🗂️ Cleanup of export and backup folders (optional)"
  echo
  read -rp "Do you want to delete the backup and export folders? (y/N): " CLEAN_CHOICE
  if [[ "$CLEAN_CHOICE" =~ ^[Yy]$ ]]; then
    return 0
  else
    echo "⏭️ Deletion skipped."
    return 1
  fi
}
