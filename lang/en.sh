#!/bin/bash

# 🇫🇷 Language file - French

# ==================================================================
# ✅ GENERAL MESSAGES - All chapters
# ==================================================================

# Local warnings
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

msg_lang="🌍 Selected language: French"
msg_select_language="🌐 Choose your language:"
msg_select_english="1) French"
msg_select_french="2) English"
msg_invalid_choice="❌ Invalid choice. French selected by default."

# Common user prompts
msg_prompt_domain="Enter your domain (e.g. example.com)"
msg_prompt_mail_from="Shipping email address"
msg_prompt_mail_dest="Destination email address (test)"
msg_prompt_mail_fqdn="Enter your FQDN mail server name (e.g. mail.domain.tld)"
msg_prompt_confirm="Do you wish to continue? (o/n)"

# 🔐 General messages for UFW firewall management (used across chapters)

msg_ufw_not_installed="UFW is not installed. No active firewall detected."
msg_active_ufw="✅ UFW is already enabled."
msg_inactive_ufw="❌ UFW is not enabled on this server."
msg_ufw_keep_enabled="UFW is enabled. Do you want to keep it enabled?"
msg_ufw_disabling="Disabling UFW..."
msg_ufw_disabled="UFW has been disabled."
msg_enable_ufw="Would you like to enable UFW to secure your server?"
msg_ufw_left_disabled="UFW was left disabled."
msg_open_ports="🌐 Opening required firewall ports..."
msg_open_ports_complete_chap2="✅ Ports were opened and UFW was enabled."
msg_press_enter="Press [Enter] to continue..."


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
#📘 Chapter 02 - Installing Postfix and Dovecot
# ==================================================================

# ------------------------------------------------------------------
# 📘 Introduction and steps
# ------------------------------------------------------------------

msg_intro_chap2=“🎉 Welcome to the installation script for your secure email server with Postfix and Dovecot.”
msg_steps_chap2="📜 This script will follow these steps:
1. Check the status of **UFW** (firewall) and activate it if necessary.
2. Open the ports needed for email management.
3. Installing **Postfix** for outgoing email management (SMTP).
4. Installing **Dovecot** for incoming email management (IMAP/POP3).
5. Activating **TLS** encryption to secure communications.
6. Testing to verify that the services are configured correctly."


msg_banner_chap2=“###########################################\n💼 Postfix & Dovecot – Mail Server Setup 💼\n###########################################”

# ------------------------------------------------------------------
# 📘 Status messages for UFW and port opening
# ------------------------------------------------------------------

msg_active_ufw_chap2=“✅ UFW is already enabled.”
msg_inactive_ufw_chap2="❌ UFW is not enabled on this server."
msg_enable_ufw_chap2="Would you like to enable UFW to secure your server? (y/n)"
msg_open_ports_chap2=“🌐 Opening the necessary ports in the firewall...”
msg_open_ports_complete_chap2="✅ The ports have been successfully opened."

# ------------------------------------------------------------------
# 📘 Confirmation messages for installation and testing
# ------------------------------------------------------------------
msg_install_postfix_chap2=“🌐 Installing Postfix...”
msg_install_dovecot_chap2="🌐 Installing Dovecot..."
msg_test_email_chap2="🌐 Testing sending an email via Postfix. You will enter the **subject** and **description** of the email."
msg_prompt_subject=“Please enter the subject of the email”
msg_prompt_description="Please enter the description of the email"
msg_test_imap_chap2="🌐 Testing the IMAP connection via Dovecot..."
msg_restart_services_chap2="🌐 Restarting Postfix and Dovecot..."
msg_success_chap2=“🎉 Mail server configuration completed successfully!”

# ------------------------------------------------------------------
# 📘 Messages to check the status of services
# ------------------------------------------------------------------
msg_config_test_postfix_chap2="🌐 Checking Postfix configuration..."
msg_config_test_dovecot_chap2=“🌐 Checking Dovecot configuration...”

# ------------------------------------------------------------------
# 📘 New dynamic messages to add
# ------------------------------------------------------------------
msg_check_ufw_chap2="🌐 Checking UFW (firewall) status..."
msg_postfix_config_chap2() { echo “Configuring Postfix with domain $DOMAIN...”; }
msg_dovecot_maildir_config_chap2="Configuring Dovecot for Maildir..."
msg_dovecot_tls_config_chap2="Configuring Dovecot for TLS..."

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