
# 📘 Guide complet – Chapitre 1 : Préparation Ubuntu + Sécurisation SSH + Envoi d’e-mails SMTP (Postfix)

## 🧭 À qui s’adresse ce guide ?

Ce guide est pensé pour un large public, du débutant complet à l’administrateur système confirmé. Il peut être utilisé pour apprendre, pour documenter une configuration d’entreprise, ou pour transmettre un savoir-faire professionnel. Chaque étape est expliquée en détail, sans jargon inutile, avec des commentaires pratiques et des recommandations applicables en environnement réel.

---

## 🎯 Objectif global du Chapitre 1

Mettre en place une base Ubuntu propre, sécurisée et prête à envoyer des e-mails sortants via SMTP en utilisant le serveur Postfix. Ce chapitre ne couvre pas la réception des e-mails (qui sera traitée dans le Chapitre 2).

---

Sommaire

##Partie 1 – Préparation de la base Ubuntu

	# Étape 1 – Mettre à jour complètement le système
	# Étape 2 – Définir le nom d’hôte (hostname)
	# Étape 3 – Ajouter ce nom dans le fichier /etc/hosts
	# Étape 4 – Définir le fuseau horaire du serveur
	# Étape 5 – Régénérer les locales du système
	# Étape 6 – Vérifier la connectivité Internet
	# Étape 7 – Installer le serveur SSH
	# Étape 8 – Sécuriser l’accès SSH
	# Étape 9 – Activer le pare-feu UFW
	# Étape 10 – Vérifier le statut du pare-feu


##📈 Chapitre 1 – Préparation de la base Ubuntu

	# 🧱 Étape 1 – Mise à jour complète du système Ubuntu

Avant d’installer un logiciel ou d’ouvrir votre serveur au réseau, il est fondamental de commencer par mettre à jour le système. Cela permet de bénéficier des derniers correctifs de sécurité, des améliorations de performance, et d’assurer une compatibilité parfaite avec les paquets que vous allez installer ensuite comme Postfix ou Dovecot.

Ubuntu utilise apt, son gestionnaire de paquets, pour effectuer ces mises à jour. La commande suivante est composée de trois parties :

apt update : récupère les dernières informations des dépôts en ligne.

apt upgrade -y : installe toutes les mises à jour disponibles automatiquement.

apt autoremove --purge -y : nettoie les paquets devenus inutiles (anciens noyaux, dépendances orphelines, etc.)

Cette étape est indispensable sur un serveur neuf. Elle est rapide et sans danger, surtout si vous venez de terminer l’installation d’Ubuntu.

```bash
apt update && apt upgrade -y && apt autoremove --purge -y
```

---

	# 🧱 Étape 2 – Définir le nom d’hôte (hostname)

Le nom d’hôte est ce que le système va utiliser pour s’identifier lui-même. C’est aussi ce que Postfix affichera dans les en-têtes de courriel, ce que les journaux système retiendront, et ce que vous verrez sur votre terminal. Il est fortement recommandé d’utiliser un **FQDN** (Fully Qualified Domain Name) comme `mail.domain.tld` pour assurer une cohérence avec vos enregistrements DNS et reverse DNS.

Ce nom d’hôte doit être défini avec la commande `hostnamectl`, qui met à jour à la fois le fichier `/etc/hostname` et la configuration en mémoire. Ne modifiez pas ce fichier à la main. Cette commande est fiable, propre, et persistante au redémarrage.

Ne pas définir correctement le nom d’hôte peut provoquer des messages d’erreur dans Postfix comme `myhostname is not a fully qualified domain name`. Cela peut aussi poser problème si le serveur ne peut pas résoudre son propre nom, ce qui perturbe l’envoi de mails.

```bash
hostnamectl set-hostname mail.domain.tld
```

---

	# 🧱 Étape 3 – Ajouter l’entrée locale dans /etc/hosts

Même si vous utilisez un DNS externe pour votre domaine, le système Ubuntu doit pouvoir résoudre son propre nom localement. C’est une sécurité et une bonne pratique. Sans cette ligne, vous risquez des erreurs lors du démarrage de certains services comme Postfix ou Dovecot, ou des lenteurs lors des connexions réseau internes.

Le fichier `/etc/hosts` agit comme un mini-DNS local : c’est la première chose que le système consulte pour résoudre un nom. Ajouter `127.0.1.1 mail.domain.tld` permet à la machine de s’identifier rapidement, même sans connexion Internet. Cela évite aussi les erreurs de type "unable to lookup my own hostname".

Utilisez un éditeur comme `nano` ou `vim` pour modifier ce fichier. Vérifiez qu’il contient bien ces deux lignes :

```bash
nano /etc/hosts
```
Et ajoutez/modifiez les lignes suivantes :
```bash
127.0.0.1 localhost
127.0.1.1 mail.domain.tld
```

	# Étape 4 – Définir le fuseau horaire du serveur

Définir un fuseau horaire correct est indispensable pour garantir la cohérence horaire dans tous les journaux système, les horodatages de mails, les tâches cron, et la gestion des certificats SSL. Sur un serveur hébergé en France ou destiné à des utilisateurs francophones, on utilisera généralement Europe/Paris.

L’outil timedatectl permet de configurer le fuseau horaire facilement. Il applique immédiatement les changements, et ils sont persistants au redémarrage. Il est possible de voir la liste complète des fuseaux horaires disponibles avec :
```bash
timedatectl list-timezones | grep Europe
```

Une fois que vous avez identifié celui qui vous convient (dans la majorité des cas Europe/Paris), utilisez :

```bash
timedatectl set-timezone Europe/Paris
```
Vous pouvez ensuite vérifier que l’heure est correcte avec :

```bash
timedatectl status
```
L’heure affichée doit correspondre à l’heure locale de votre région, ce qui est primordial pour les logs, les envois d’e-mails et toute tâche planifiée.

	# Étape 5 – Configurer la langue et l’encodage (locales)

Configurer les locales permet d’assurer une bonne prise en charge des accents, des caractères spéciaux et d’avoir des messages système dans la langue de votre choix. Cela est aussi important pour l’affichage correct des logs, des mails système, ou lors de l’installation de logiciels. En France ou pour une interface francophone, on utilise fr_FR.UTF-8, qui garantit un encodage universel.

Générez la locale avec :

```bash
locale-gen fr_FR.UTF-8
```

Puis relancez le système de configuration des locales :

```bash
dpkg-reconfigure locales
```

Choisissez fr_FR.UTF-8 comme valeur par défaut. Le système utilisera alors ce format pour tout ce qui est date, heure, tri alphabétique, affichage des messages.

	# Étape 6 – Vérifier la connexion Internet et le DNS

Avant d’aller plus loin, il est indispensable de vérifier que votre serveur est connecté à Internet et qu’il est capable de résoudre les noms de domaine. Sans cela, vous ne pourrez ni installer de paquets, ni envoyer de mails.

Pour tester la connectivité réseau :

```bash
ping -c 3 1.1.1.1
```

Si vous avez une réponse, la connexion est active. Puis vérifiez la résolution DNS :

```bash
dig google.fr +short
```
Vous devez obtenir une ou plusieurs adresses IP. Si ce n’est pas le cas, il faudra revoir la configuration réseau (IP statique, DNS, etc.).

	# Étape 7 – Installer le serveur SSH

Le service SSH (Secure Shell) est indispensable pour administrer votre serveur à distance. Il permet de vous connecter en toute sécurité via un terminal. La majorité des hébergements Ubuntu le proposent préinstallé, mais si ce n’est pas le cas, installez-le avec :

```bash
apt install openssh-server -y
```

Une fois installé, SSH démarre automatiquement. Vérifiez qu’il est actif avec :

```bash
systemctl status ssh
```

Vous pouvez maintenant accéder à votre serveur depuis un autre ordinateur avec :

```bash
ssh utilisateur@ip -p 22
```

	# Étape 8 – Modifier le port SSH pour plus de sécurité

Par défaut, SSH utilise le port 22. Ce port est bien connu et souvent scanné par les robots malveillants. Pour renforcer la sécurité, il est recommandé d’utiliser un port personnalisé comme 10523.

Éditez la configuration SSH :

```bash
nano /etc/ssh/sshd_config
```

Remplacez :

#Port 22

par :

Port 10523

Enregistrez et quittez. Pensez à ouvrir ce port dans UFW avant de redémarrer SSH pour ne pas vous bloquer.

```bash
ufw allow 10523/tcp
systemctl restart ssh
```

Vous devrez désormais vous connecter avec :

```bash
ssh utilisateur@ip -p 10523
```

	# Étape 9 – Interdire l’accès SSH en root (bonne pratique)

Par sécurité, il est fortement déconseillé de permettre une connexion directe du compte root par SSH. À la place, on se connecte avec un utilisateur normal, puis on élève les privilèges avec sudo.

Dans /etc/ssh/sshd_config, assurez-vous que la ligne suivante existe :

PermitRootLogin no

Cela empêche toute connexion directe de root à distance. Redémarrez ensuite le service :

```bash
systemctl restart ssh
```

	# Étape 10 – Activer le pare-feu et n’autoriser que ce qui est nécessaire

Ubuntu fournit un pare-feu intégré nommé UFW (Uncomplicated Firewall). Il est simple à utiliser et efficace. Il est conseillé de le configurer très tôt dans le processus pour n’ouvrir que les ports nécessaires.

Activez UFW et ouvrez les ports SSH et futurs ports mail (à adapter plus tard) :

```bash
ufw allow 10523/tcp
ufw allow 25/tcp
ufw allow 587/tcp
ufw allow 465/tcp
ufw enable
```

Vérifiez la configuration :

```bash
ufw status verbose
```
Cela vous montrera quels ports sont autorisés et depuis quelles adresses. Il est conseillé de n’autoriser que le strict nécessaire.
