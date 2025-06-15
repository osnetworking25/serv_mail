```bash
# Part 4: How to Set up SPF and DKIM with Postfix on Ubuntu Server

# === Step 1: Create an SPF Record in DNS ===
# In your DNS management interface, create a new TXT record like below.

# TXT  @   v=spf1 mx ~all
# create spf record in DNS

# Explanation:

# TXT indicates this is a TXT record.

# Enter @ in the name field.

# TXT  @   "v=spf1 mx ~all"

dig your-domain.com txt
# The txt option tells dig that we only want to query TXT records.


# === Step 2: Configuring SPF Policy Agent ===

sudo apt install postfix-policyd-spf-python
# Then edit the Postfix master process configuration file.

sudo nano /etc/postfix/master.cf
# Add the following lines at the end of the file, which tells Postfix to start the SPF policy daemon when it’s starting itself.

 policyd-spf  unix  -       n       n       -       0       spawn
     user=policyd-spf argv=/usr/bin/policyd-spf
	
# Save and close the file. Next, edit Postfix main configuration file.

sudo nano /etc/postfix/main.cf

# Append the following lines at the end of the file. 

 policyd-spf_time_limit = 3600
 smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,
    reject_unauth_destination,
    check_policy_service unix:private/policyd-spf
   
# Save and close the file. Then restart Postfix.

sudo systemctl restart postfix

# Next time, when you receive an email from a domain that has an SPF record, you can see the SPF check results in the raw email header. The following header indicates the sender sent the email from an authorized host.

# Received-SPF: Pass (sender SPF authorized).

# === Step 3: Setting up DKIM ===

# install OpenDKIM which is an open-source implementation of the DKIM sender authentication system.

sudo apt install opendkim opendkim-tools
# Then add postfix user to opendkim group.

sudo gpasswd -a postfix opendkim
# Edit OpenDKIM main configuration file.

sudo nano /etc/opendkim.conf
# Find the following line.

Syslog               yes
# By default,  OpenDKIM logs will be saved in /var/log/mail.log file. Add the following line so OpenDKIM will generate more detailed logs for debugging.

Logwhy               yes
opendkim logwhy yes

# Locate the following lines.

#Domain                 example.com
#KeyFile                /etc/dkimkeys/dkim.key
#Selector               2007
# By default, they are commented out. Please don’t uncomment them.

# Then, find the following lines. Uncomment them and replace simple with relaxed/simple.

#Canonicalization   simple
#Mode               sv
#SubDomains         no

# Then add the following lines below #ADSPAction continue line. If your file doesn’t have #ADSPAction continue line, then just add them below SubDomains  no.

# AutoRestart         yes
# AutoRestartRate     10/1M
# Background          yes
# DNSTimeout          5
# SignatureAlgorithm  rsa-sha256
# ubuntu opendkim canonicalization

# add the following lines at the end of this file. (Note that On Ubuntu 18.04 and 20.04, the UserID is already set to opendkim)

#OpenDKIM user
# Remember to add user postfix to group opendkim
UserID             opendkim

# Map domains in From addresses to keys used to sign messages
KeyTable           refile:/etc/opendkim/key.table
SigningTable       refile:/etc/opendkim/signing.table

# Hosts to ignore when verifying signatures
ExternalIgnoreList  /etc/opendkim/trusted.hosts

# A set of internal hosts whose mail should be signed
InternalHosts       /etc/opendkim/trusted.hosts
Save and close the file.

# === Step 4: Create Signing Table, Key Table and Trusted Hosts File ===

# Create a directory structure for OpenDKIM

sudo mkdir /etc/opendkim

sudo mkdir /etc/opendkim/keys

# Change the owner from root to opendkim and make sure only opendkim user can read and write to the keys directory.

sudo chown -R opendkim:opendkim /etc/opendkim

sudo chmod go-rw /etc/opendkim/keys

# Create the signing table.

sudo nano /etc/opendkim/signing.table

# Add the following two lines to the file. 

 *@your-domain.com    default._domainkey.your-domain.com
 *@*.your-domain.com    default._domainkey.your-domain.com

# Save and close the file. Then create the key table.

sudo nano /etc/opendkim/key.table

# Add the following line, which tells the location of the private key.

 default._domainkey.your-domain.com     your-domain.com:default:/etc/opendkim/keys/your-domain.com/default.private
# Save and close the file. Next, create the trusted hosts file.

sudo nano /etc/opendkim/trusted.hosts

# Add the following lines to the newly created file. This tells OpenDKIM that if an email is coming from localhost or from the same domain, then OpenDKIM should only sign the email but not perform DKIM verification on the email.

 127.0.0.1
 localhost

 .your-domain.com
# Save and close the file.

# Note: You should not add an asterisk in the domain name like this: *.your-domain.com. There should be only a dot before the domain name.

# === Step 5: Generate Private/Public Keypair ===

# Create a separate folder for the domain.

sudo mkdir /etc/opendkim/keys/your-domain.com

# Generate keys using opendkim-genkey tool.

sudo opendkim-genkey -b 2048 -d your-domain.com -D /etc/opendkim/keys/your-domain.com -s default -v

# The above command will create 2048 bits keys. -d (domain) specifies the domain. -D (directory) specifies the directory where the keys will be stored and we use default as the selector (-s), also known as the name. Once the command is executed, the private key will be written to default.private file and the public key will be written to default.txt file.

# Make opendkim as the owner of the private key.

sudo chown opendkim:opendkim /etc/opendkim/keys/your-domain.com/default.private

# And change the permission, so only the opendkim user has read and write access to the file.

sudo chmod 600 /etc/opendkim/keys/your-domain.com/default.private

# === Step 6: Publish Your Public Key in DNS Records ===

# Display the public key

sudo cat /etc/opendkim/keys/your-domain.com/default.txt

# In your DNS manager, create a TXT record, enter default._domainkey in the name field. 

# copy everything between the parentheses and paste it into the value field of the DNS record. 

# You need to delete all double quotes and white spaces in the value field. If you don’t delete them, then the key test in the next step will probably fail.

# dkim record

# === Step 7: Test DKIM Key ===

# Enter the following command on Ubuntu server to test your key.

sudo opendkim-testkey -d your-domain.com -s default -vvv

# If everything is OK, you will see Key OK in the command output.

opendkim-testkey: using default configfile /etc/opendkim.conf

opendkim-testkey: checking key 'default._domainkey.your-domain.com'
opendkim-testkey: key secure
opendkim-testkey: key OK


# If you see the query timed out error, you need to comment out the following line in /etc/opendkim.conf file and restart opendkim.service.

 TrustAnchorFile       /usr/share/dns/root.key

# === Step 8: Connect Postfix to OpenDKIM ===

# Postfix can talk to OpenDKIM via a Unix socket file. The default socket file used by OpenDKIM is /var/run/opendkim/opendkim.sock, as shown in /etc/opendkim.conf file. But the postfix SMTP daemon shipped with Ubuntu runs in a chroot jail, which means the SMTP daemon resolves all filenames relative to the Postfix queue directory (/var/spool/postfix). So we need to change the OpenDKIM Unix socket file.

# Create a directory to hold the OpenDKIM socket file and allow only opendkim user and postfix group to access it.

sudo mkdir /var/spool/postfix/opendkim

sudo chown opendkim:postfix /var/spool/postfix/opendkim

# Then edit the OpenDKIM main configuration file.

sudo nano /etc/opendkim.conf


# For (Ubuntu 22.04/20.04)

Socket    local:/run/opendkim/opendkim.sock
# Replace it with the following line. (If you can’t find the above line, then add the following line.)

 Socket    local:/var/spool/postfix/opendkim/opendkim.sock
# Save and close the file.

# If you can find the following line in /etc/default/opendkim file.

 SOCKET="local:/var/run/opendkim/opendkim.sock"
# or

 SOCKET=local:$RUNDIR/opendkim.sock
# Change it to

 SOCKET="local:/var/spool/postfix/opendkim/opendkim.sock"
opendkim socket

# Save and close the file.

# Next, we need to edit the Postfix main configuration file.

sudo nano /etc/postfix/main.cf

# Add the following lines at the end of this file, 

 Milter configuration
 milter_default_action = accept
 milter_protocol = 6
 smtpd_milters = local:opendkim/opendkim.sock
 non_smtpd_milters = $smtpd_milters

# Save and close the file.

# Then restart opendkim and postfix service.
sudo systemctl restart opendkim postfix

# === Step 9: SPF and DKIM Check ===

# You can now send a test email from your mail server to your Gmail account to see if SPF and DKIM checks are passed. On the right side of an opened #email message in Gmail, if you click the show original button from the drop-down menu, you can see the authentication results.

# Gmail SPF and DKIM check scalahosting

# Your email server will also perform SPF and DKIM checks on the sender’s domain. You can see the results in the email headers. The following is SPF and DKIM check on a sender using Gmail.

# Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::c2d; helo=mail-yw1-xc2d.google.com; envelope-from=someone@gmail.com; receiver=<UNKNOWN> 
# Authentication-Results: email.linuxbabe.com;
# 	dkim=pass (2048-bit key; unprotected) header.d=gmail.com header.i=@gmail.com header.b="XWMRd2co";
# 	dkim-atps=neutral
# Postfix Can’t Connect to OpenDKIM
# If your message is not signed and DKIM check failed, you can check postfix log (/var/log/mail.log) to see what’s wrong with your configuration. If #you find the following error in the Postfix mail log (/var/log/mail.log),

# connect to Milter service local:opendkim/opendkim.sock: No such file or directory
# you should check if the opendkim systemd service is actually running.

systemctl status opendkim

# If opendkim is running and you still see the above error, it means Postfix can’t connect to OpenDKIM via the Unix domain socket (local:opendkim/opendkim.sock).

# To fix this error, you can configure OpenDKIM to use TCP/IP socket instead of Unix domain socket. (Unix domain socket is usually faster than TCP/IP socket. If it doesn’t work on your server, then you should use TCP/IP socket.)

sudo nano /etc/opendkim.conf
# Find the following line:

Socket   local:/var/spool/postfix/opendkim/opendkim.sock
# Replace it with

Socket     inet:8892@localhost
# So OpenDKIM will be listening on the 127.0.0.1:8892 TCP/IP socket. Save and close the file. Then edit Postfix main config file.

sudo nano /etc/postfix/main.cf
# Find the following line:

smtpd_milters = local:opendkim/opendkim.sock
# Replace it with:

smtpd_milters = inet:127.0.0.1:8892
# So Postfix will connect to OpenDKIM via the TCP/IP socket. Restart OpenDKIM and Postfix.

sudo systemctl restart opendkim postfix
# Checking the OpenDKIM Logs
# Sometimes, the OpenDKIM journal logs may help you find out what’s wrong.

sudo journalctl -eu opendkim
# For example, I once had the following error.

opendkim[474285]: key '1': dkimf_db_get(): Connection was killed
opendkim[474285]: 16F53B606: error loading key '1'
# I just need to restart OpenDKIM to fix this error.

sudo systemctl restart opendkim
# Configuration Error in Email Client
# DKIM signing could fail if you don’t use the correct SMTP/IMAP settings in your email client.

# Correct Settings:

# SMTP protocol: enter mail.your-domain.com as the server name, choose port 587 and STARTTLS. Choose normal password as the authentication method.
# IMAP protocol: enter mail.your-domain.com as the server name, choose port 143 and STARTTLS. Choose normal password as the authentication method.
# or

# SMTP protocol: enter mail.your-domain.com as the server name, choose port 465 and SSL/TLS. Choose normal password as the authentication method.
# IMAP protocol: enter mail.your-domain.com as the server name, choose port 993 and SSL/TLS. Choose normal password as the authentication method.
# Wrong Settings:

# Use port 25 as the SMTP port in mail clients to submit outgoing emails.
# No encryption method was selected.
# Port 25 should be used for SMTP server to SMTP server communication. Please don’t use it in your email client to submit outgoing emails.

# You should select an encryption method (STARTTLS or SSL/TLS) in your email client.

# Testing Email Score and Placement
# You can also go to https://www.mail-tester.com. You will see a unique email address. Send an email from your domain to this address and then check your score. As you can see, I got a perfect score.

# imporve email server reputation

# Mail-tester.com can only show you a sender score. There’s another service called GlockApps that allow you to check if your email is placed in the recipient’s inbox or spam folder, or rejected outright. It supports many popular email providers like Gmail, Outlook, Hotmail, YahooMail, iCloud mail, etc

# glockapps email placement test scalahosting

# Microsoft Mailboxes
# In my test, the email landed in my Gmail inbox. However, it’s stilled labeled as spam in my outlook.com email although both SPF and DKIM are passed.

# Microsoft uses an internal blacklist that blocks many legitimate IP addresses. If your emails are rejected by Outlook or Hotmail, you need to follow the tutorial linked below to bypass the Microsoft Outlook blacklist.

# How to Bypass the Microsoft Outlook Blacklist & Other Blacklists
# What if Your Emails Are Still Being Marked as Spam?
# The most important two factors are domain reputation and IP reputation. You can use an email warm-up service to improve your reputation automatically.

# Automatic IP and Domain Warm-up For Your Email Server
# I have more tips for you in this article:

# 7 effective tips to stop your emails from being marked as spam
# Next Step
# In part 5, we will see how to create DMARC record to protect your domain from email spoofing. As always, if you found this post useful, please subscribe to our free newsletter or follow us on Twitter, or like our Facebook page.
```