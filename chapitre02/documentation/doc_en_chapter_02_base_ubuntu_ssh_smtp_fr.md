
# 📘 Complete Guide – Chapter 2: Installing Postfix (SMTP server)

## 🧭 Who is this guide for?

This guide is designed for a wide audience, from complete beginners to experienced system administrators. It can be used for learning, documenting a corporate configuration, or sharing professional expertise. Each step is explained in detail, without unnecessary jargon, with practical comments and recommendations applicable in a real-world environment.

---

## 🎯 Overall objective of Chapter 2

Set up a clean, secure Ubuntu base that is ready to send outgoing emails via SMTP using the Postfix server. This chapter does not cover receiving emails (which will be covered in Chapter 2).

---

Summary

## Chapter 2 – Installing Postfix (SMTP server)
- Step 1 – Install Postfix and mail utilities
	- Step 2 – Verify that Postfix is active and functioning
- Step 3 – Verify listening on port 25 (SMTP)
- Step 4 – Open port 25 in UFW (if active)
- Step 5 – Test SMTP output to the Internet (Gmail)
- Step 6 – Send a simple test email
	- Step 7 – Check that the message has been sent
- Step 8 – Check the local mailbox (root user)
- Step 9 – Configure the postmaster: and root: aliases
- Step 10 – Restart Postfix to apply the changes


## 📬 Chapter 2  2 – Installing Postfix (SMTP server)

	# Step 1 – Install Postfix and mail utilities

Postfix is an SMTP (Simple Mail Transfer Protocol) mail server renowned for its reliability, speed, and security. It allows your server to send outgoing emails to other servers. To be able to test sending emails easily, we also install the mailutils package, which provides the mail command.

The installation is done from the Ubuntu repositories, and the default configuration mode allows you to define your domain.

```bash
apt install postfix mailutils -y
```

During installation, select the Website type. When asked for a domain name, enter domain.tld (or your own, for example osnetworking.com).

	# Step 2 – Check that Postfix is active and working

After installation, Postfix should be automatically activated and launched. Check this with:

```bash
systemctl status postfix
```

You can also check the installed version:

```bash
postconf mail_version
```

This will show you, for example, mail_version = 3.6.4, which confirms that Postfix is up and running.

    # Step 3 – Check listening on port 25 (SMTP)

Port 25 is the port used to send emails between servers. Your Postfix must listen to this port in order to function properly.

Use the following command:

```bash
ss -lnpt | grep :25
```

You should see a line indicating that the Postfix master service is listening on 0.0.0.0:25 (or ::: for IPv6).

    # Step 4 – Open port 25 in UFW (if active)

If your UFW firewall is enabled, you must explicitly allow incoming connections on port 25 (SMTP). Otherwise, no mail can be sent or accepted.

```bash
ufw allow 25/tcp
```

Check that the rule is applied:

```bash
ufw status numbered
```

	# Step 5 – Test SMTP output to the Internet (Gmail)

Even if Postfix works locally, it is common for hosting providers (OVH, Scaleway, Oracle, etc.) to block port 25 output to prevent spam. So check that your server can contact a remote SMTP server, such as Gmail's:

```bash
telnet gmail-smtp-in.l.google.com 25

You should get a response like:

220 mx.google.com ESMTP...
```
Type QUIT to close the session:

```bash
QUIT
```

If the command remains blocked or fails, your outgoing port 25 is probably blocked. You will need to ask your host to open it.

    # Step 6 – Send a simple test email

To test sending an email, you can use the sendmail command that comes with Postfix. This command sends a plain text message to an external address to verify that outgoing SMTP is working properly.

```bash
echo “SMTP test from Postfix” | sendmail adresse@email.com
```

You can also use the mail command (provided by mailutils) to send a message with a subject:

```bash
mail -s “Test subject” destinataire@email.com
```

Then type the body of the message, confirm with Enter, and finish with Ctrl + D to send.

    # Step 7 – Check that the message has been sent

Check the Postfix logs to confirm that the message has been sent:

```bash
tail -f /var/log/mail.log
```

You should see a line indicating status=sent if everything went well.

    # Step 8 – Check the local mailbox (root user)

By default, messages intended for root or generated locally may be stored in /var/mail/root or /var/spool/mail/root. Check this folder:

```bash
ls -l /var/mail/
```
# Step 9 – Configure the postmaster: and root: aliases

Editing the /etc/aliases file allows you to redirect system emails (intended for postmaster, root, etc.) to a real address that you check.

```bash
nano /etc/aliases
```

Add or modify the following lines:

```bash
postmaster:    root
root:          votre@email.com
```

Apply the change with:

```bash
newaliases
```

    # Step 10 – Restart Postfix to apply the changes

```bash
systemctl restart postfix
```
This ensures that the modified files (main.cf, aliases, etc.) are re-read correctly.

    # Glossary of terms used

DNS

A system that allows a readable address (such as mail.osnetworking.com) to be associated with an IP address. It functions as a distributed global directory.

FQDN

The server's fully qualified domain name, including the host name and the main domain (e.g., mail.domain.tld).

SMTP

Protocol used to send emails between servers. This is the role of Postfix in this guide.

SSH

Secure protocol for remote access to a server. It replaces Telnet, which is unsecure.

UFW

Uncomplicated Firewall. Easy-to-use firewall integrated into Ubuntu to manage network security rules.

## FAQ – Frequently asked questions and solutions

Problem: port 25 appears to be closed

Check with ss -lnpt | grep :25

```bash
ss -lnpt | grep :25
```

If nothing appears:

Postfix is not started: systemctl start postfix

UFW is blocking the port:

```bash
ufw allow 25/tcp
```

Problem: mail not received by the recipient

Check the logs:

```bash
tail -f /var/log/mail.log
```

Common problems: DNS error, blocked by outgoing port 25, rejected by recipient

Problem: I am not receiving system emails at my address

Check that the /etc/aliases file contains:

root: my server

Then:

```bash
newaliases && systemctl restart postfix
```