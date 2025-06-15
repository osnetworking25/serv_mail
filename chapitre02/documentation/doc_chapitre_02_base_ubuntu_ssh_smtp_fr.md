
# 📘 Guide complet – Chapitre 2 : stallation de Postfix (serveur SMTP

## 🧭 À qui s’adresse ce guide ?

Ce guide est pensé pour un large public, du débutant complet à l’administrateur système confirmé. Il peut être utilisé pour apprendre, pour documenter une configuration d’entreprise, ou pour transmettre un savoir-faire professionnel. Chaque étape est expliquée en détail, sans jargon inutile, avec des commentaires pratiques et des recommandations applicables en environnement réel.

---

## 🎯 Objectif global du Chapitre 2

Mettre en place une base Ubuntu propre, sécurisée et prête à envoyer des e-mails sortants via SMTP en utilisant le serveur Postfix. Ce chapitre ne couvre pas la réception des e-mails (qui sera traitée dans le Chapitre 2).

---

Sommaire

## Chapitre 2 – Installation de Postfix (serveur SMTP)
	- Étape 1 – Installer Postfix et les utilitaires mail
	- Étape 2 – Vérifier que Postfix est actif et fonctionne
	- Étape 3 – Vérifier l’écoute sur le port 25 (SMTP)
	- Étape 4 – Ouvrir le port 25 dans UFW (si actif)
	- Étape 5 – Tester la sortie SMTP vers Internet (Gmail)
	- Étape 6 – Envoyer un mail de test simple
	- Étape 7 – Vérifier que le message a été envoyé
	- Étape 8 – Vérifier la boîte locale (utilisateur root)
	- Étape 9 – Configurer les alias postmaster: et root:
	- Étape 10 – Redémarrer Postfix pour prendre en compte les changements


## 📬 Chapitre 2  2 – Installation de Postfix (serveur SMTP)

	# Étape 1 – Installer Postfix et les utilitaires mail

Postfix est un serveur de messagerie SMTP (Simple Mail Transfer Protocol) réputé pour sa fiabilité, sa rapidité et sa sécurité. Il permet à votre serveur d'envoyer des e-mails sortants vers d'autres serveurs. Pour pouvoir tester l'envoi de mails facilement, on installe aussi le paquet mailutils qui fournit la commande mail.

L'installation se fait depuis les dépôts Ubuntu, et le mode de configuration proposé par défaut vous permet de définir votre domaine.

```bash
apt install postfix mailutils -y
```

Pendant l’installation, sélectionnez le type Site Internet. Quand il vous demande un nom de domaine, saisissez domain.tld (ou le vôtre, par exemple osnetworking.com).

	# Étape 2 – Vérifier que Postfix est actif et fonctionne

Après l’installation, Postfix doit être automatiquement activé et lancé. Vérifiez cela avec :

```bash
systemctl status postfix
```

Vous pouvez également vérifier la version installée :

```bash
postconf mail_version
```

Cela vous indiquera par exemple mail_version = 3.6.4, ce qui confirme que Postfix est bien en place.

	# Étape 3 – Vérifier l’écoute sur le port 25 (SMTP)

Le port 25 est celui utilisé pour envoyer les e-mails entre serveurs. Votre Postfix doit impérativement l’écouter en entrée pour pouvoir fonctionner correctement.

Utilisez la commande suivante :

```bash
ss -lnpt | grep :25
```

Vous devez voir une ligne indiquant que le service master de Postfix est à l’écoute sur 0.0.0.0:25 (ou ::: pour IPv6).

	# Étape 4 – Ouvrir le port 25 dans UFW (si actif)

Si votre pare-feu UFW est activé, vous devez explicitement autoriser les connexions entrantes sur le port 25 (SMTP). Sinon, aucun mail ne pourra être envoyé ou accepté.

```bash
ufw allow 25/tcp
```

Vérifiez que la règle est bien appliquée :

```bash
ufw status numbered
```

	# Étape 5 – Tester la sortie SMTP vers Internet (Gmail)

Même si Postfix fonctionne localement, il est fréquent que des hébergeurs (OVH, Scaleway, Oracle…) bloquent le port 25 en sortie pour éviter le spam. Vérifiez donc que votre serveur peut contacter un serveur SMTP distant, comme celui de Gmail :

```bash
telnet gmail-smtp-in.l.google.com 25

Vous devez obtenir une réponse comme :

220 mx.google.com ESMTP...
```
Tapez QUIT pour fermer la session :

```bash
QUIT
```

Si la commande reste bloquée ou échoue, votre port 25 sortant est probablement bloqué. Il faudra demander son ouverture à votre hébergeur.

	# Étape 6 – Envoyer un mail de test simple

Pour tester l’envoi d’un e-mail, vous pouvez utiliser la commande sendmail qui est fournie avec Postfix. Cette commande envoie un message en texte brut à une adresse externe pour vérifier le bon fonctionnement du SMTP sortant.

```bash
echo "Test SMTP depuis Postfix" | sendmail adresse@email.com
```

Vous pouvez aussi utiliser la commande mail (fournie par mailutils) pour envoyer un message avec un objet :

```bash
mail -s "Sujet du test" destinataire@email.com
```

Tapez ensuite le corps du message, puis validez avec Entrée, et terminez par Ctrl + D pour envoyer.

	# Étape 7 – Vérifier que le message a été envoyé

Consultez les logs de Postfix pour confirmer que le message est bien parti :

```bash
tail -f /var/log/mail.log
```

Vous devriez voir une ligne indiquant status=sent si tout s’est bien passé.

	# Étape 8 – Vérifier la boîte locale (utilisateur root)

Par défaut, les messages destinés à root ou générés localement peuvent être stockés dans /var/mail/root ou /var/spool/mail/root. Vérifiez ce dossier :

```bash
ls -l /var/mail/
```

Puis utilisez la commande suivante pour lire le message :

```bash
mail
```

	# Étape 9 – Configurer les alias postmaster: et root:

Modifier le fichier /etc/aliases permet de rediriger les e-mails système (destinés à postmaster, root, etc.) vers une adresse réelle que vous consultez.

```bash
nano /etc/aliases
```

Ajoutez ou modifiez les lignes suivantes :

```bash
postmaster:    root
root:          votre@email.com
```

Appliquez la modification avec :

```bash
newaliases
```

	# Étape 10 – Redémarrer Postfix pour prendre en compte les changements

```bash
systemctl restart postfix
```
Cela garantit que les fichiers modifiés (main.cf, aliases, etc.) sont relus correctement.

	# Lexique des termes utilisés

DNS

Système qui permet d’associer une adresse lisible (comme mail.osnetworking.com) à une adresse IP. Il fonctionne comme un annuaire mondial distribué.

FQDN

Nom de domaine complet du serveur, incluant le nom d’hôte et le domaine principal (ex : mail.domain.tld).

SMTP

Protocole utilisé pour envoyer des emails entre serveurs. C’est le rôle de Postfix dans ce guide.

SSH

Protocole sécurisé pour accéder à distance à un serveur. Il remplace Telnet, qui est non sécurisé.

UFW

Uncomplicated Firewall. Pare-feu simple d’utilisation intégré à Ubuntu pour gérer les règles de sécurité réseau.

## FAQ – Problèmes fréquents et solutions

Problème : le port 25 semble fermé

Vérifiez avec ss -lnpt | grep :25

```bash
ss -lnpt | grep :25
```

Si rien n’apparaît :

Postfix n’est pas démarré : systemctl start postfix

UFW bloque le port : 

```bash
ufw allow 25/tcp
```

Problème : mail non reçu par le destinataire

Vérifiez les logs :

```bash
tail -f /var/log/mail.log
```

Problèmes fréquents : erreur de DNS, blocage par le port 25 sortant, rejet côté destinataire

Problème : je ne reçois pas de mail système sur mon adresse

Vérifiez que le fichier /etc/aliases contient bien :

root: mon serveur

Puis :

```bash
newaliases && systemctl restart postfix
```