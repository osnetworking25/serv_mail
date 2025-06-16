
# 📘 Complete guide - Chapter 1: Preparing Ubuntu + Securing SSH + Sending SMTP e-mails (Postfix)

## 🧭 Who is this guide for?

This guide is designed for a wide audience, from complete beginners to experienced system administrators. It can be used to learn, to document a corporate configuration, or to pass on professional know-how. Each step is explained in detail, without unnecessary jargon, with practical comments and recommendations applicable in a real-life environment.

---

## 🎯 Overall aim of Chapter 1

Set up a clean, secure Ubuntu base ready to send outgoing e-mails via SMTP using the Postfix server. This chapter does not cover receiving e-mails (which will be covered in Chapter 2).

---

Contents

##Part 1 - Preparing the Ubuntu base

	# Step 1 - Completely update the system
	# Step 2 - Set hostname
	# Step 3 - Add this name to the /etc/hosts file
	# Step 4 - Set server time zone
	# Step 5 - Regenerate system locales
	# Step 6 - Check Internet connectivity
	# Step 7 - Install SSH server
	# Step 8 - Secure SSH access
	# Step 9 - Activate UFW firewall
	# Step 10 - Check firewall status


##📈 Chapter 1 - Preparing the Ubuntu base

	# 🧱 Step 1 - Complete Ubuntu system update

Before installing any software or opening your server to the network, it's fundamental to start by updating the system. This allows you to benefit from the latest security patches, performance improvements, and ensures perfect compatibility with the packages you'll be installing next, such as Postfix or Dovecot.

Ubuntu uses apt, its package manager, to perform these updates. The following command has three parts:

apt update: retrieves the latest information from online repositories.

apt upgrade -y: installs all available updates automatically.

apt autoremove --purge -y: cleans up packages no longer required (old kernels, orphaned dependencies, etc.).

This step is essential on a new server. It's quick and safe, especially if you've just finished installing Ubuntu.

```bash
apt update && apt upgrade -y && apt autoremove --purge -y
```

---

	# 🧱 Step 2 - Define hostname

The hostname is what the system will use to identify itself. It's also what Postfix will display in email headers, what system logs will remember, and what you'll see on your terminal. It's strongly recommended to use a **FQDN** (Fully Qualified Domain Name) like `mail.domain.tld` to ensure consistency with your DNS and reverse DNS records.

This hostname should be defined with the `hostnamectl` command, which updates both the `/etc/hostname` file and the in-memory configuration. Do not modify this file by hand. This command is reliable, clean and persistent on reboot.

Failing to set the hostname correctly can lead to error messages in Postfix such as `myhostname is not a fully qualified domain name`. This can also be a problem if the server can't resolve its own name, thus disrupting mail delivery.

```bash
hostnamectl set-hostname mail.domain.tld
```

---

	# 🧱 Step 3 - Add local entry to /etc/hosts

Even if you use an external DNS for your domain, the Ubuntu system must be able to resolve its own name locally. This is a safety feature and good practice. Without this line, you risk errors when starting certain services such as Postfix or Dovecot, or slowness on internal network connections.

The `/etc/hosts` file acts as a local mini-DNS: it's the first thing the system consults to resolve a name. Adding `127.0.1.1 mail.domain.tld` allows the machine to identify itself quickly, even without an Internet connection. It also avoids "unable to lookup my own hostname" errors.

Use an editor like `nano` or `vim` to edit this file. Check that it contains these two lines:

```bash
nano /etc/hosts
```
And add/edit the following lines:

```bash
127.0.0.1 localhost
127.0.1.1 mail.domain.tld
```
	# Step 4 - Set the server's time zone

Setting the correct time zone is essential for ensuring time consistency in all system logs, e-mail timestamps, cron jobs and SSL certificate management. On a server hosted in France or intended for French-speaking users, we generally use Europe/Paris.

The timedatectl tool makes it easy to set the time zone. It applies changes immediately, and they are persistent on restart. You can view the complete list of available time zones with :
``bash
timedatectl list-timezones | grep Europe
```

Once you've identified the one that suits you best (in most cases Europe/Paris), use :

``bash
timedatectl set-timezone Europe/Paris
```
You can then check that the time is correct with :

``bash
timedatectl status
```
The time displayed should correspond to the local time in your region, which is essential for logging, e-mailing and any scheduled tasks.

	# Step 5 - Configure language and encoding (locales)

Configuring locales ensures that accents, special characters and system messages are handled in the language of your choice. This is also important for the correct display of logs, system e-mails and software installation. In France or for a French-speaking interface, we use fr_FR.UTF-8, which guarantees universal encoding.

Generate the locale with :

``bash
locale-gen fr_FR.UTF-8
```

Then restart the locale configuration system:

``bash
dpkg-reconfigure locales
```

Choose fr_FR.UTF-8 as the default value. The system will then use this format for everything from date and time to alphabetical sorting and message display.

	# Step 6 - Check Internet connection and DNS

Before going any further, it's essential to check that your server is connected to the Internet and capable of resolving domain names. Without this, you won't be able to install packages or send e-mails.

To test network connectivity :

``bash
ping -c 3 1.1.1.1
```

If you get a response, the connection is active. Then check DNS resolution:

``bash
dig google.fr +short
```
You should get one or more IP addresses. If not, you'll need to review your network configuration (static IP, DNS, etc.).

	# Step 7 - Install SSH server

The SSH (Secure Shell) service is essential for administering your server remotely. It enables you to connect securely via a terminal. Most Ubuntu hosts offer it pre-installed, but if not, install it with :

``bash
apt install openssh-server -y
```

Once installed, SSH starts automatically. Check that it's active with :

``bash
systemctl status ssh
```

You can now access your server from another computer with :

``bash
ssh user@ip -p 22
```

	# Step 8 - Change SSH port for greater security

By default, SSH uses port 22. This port is well-known and often scanned by malicious bots. To enhance security, we recommend using a custom port such as 10523.

Edit SSH configuration:

```bash
nano /etc/ssh/sshd_config
```

Replace with :

#Port 22

with :

Port 10523

Save and exit. Remember to open this port in UFW before restarting SSH to avoid getting stuck.

```bash
ufw allow 10523/tcp
systemctl restart ssh
```

You'll now need to connect with :

```bash
ssh user@ip -p 10523
```

	# Step 9 - Deny root SSH access (best practice)

To be on the safe side, we strongly advise against allowing a direct connection to the root account via SSH. Instead, log in as a normal user, then elevate privileges with sudo.

In /etc/ssh/sshd_config, make sure the following line exists:

PermitRootLogin no

This prevents any direct remote root connection. Then restart the :

```bash
systemctl restart ssh
```

	# Step 10 - Enable the firewall and allow only what's necessary

Ubuntu provides a built-in firewall called UFW (Uncomplicated Firewall). It's simple to use and effective. It's advisable to configure it early on in the process to open only the ports you need.

Activate UFW and open the SSH and future mail ports (to be adapted later):

```bash
ufw allow 10523/tcp
ufw allow 25/tcp
ufw allow 587/tcp
ufw allow 465/tcp
ufw enable
```

Check the configuration:

```bash
ufw status verbose
```
This will show you which ports are allowed and from which addresses. It is advisable to allow only what is strictly necessary.

