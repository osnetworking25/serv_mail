#!/bin/bash

echo "📦 Préparation de l'utilisateur et du dossier de stockage pour les mails virtuels..."

# 🔍 Vérification si l'utilisateur 'vmail' existe
grep -q '^vmail:' /etc/passwd
if [ $? -eq 0 ]; then
    echo "✅ L'utilisateur 'vmail' existe déjà."
else
    echo "➕ Création de l'utilisateur système 'vmail' (UID 2000, GID 2000)..."
    sudo adduser vmail --system --group --uid 2000 --disabled-login --no-create-home
    echo "✅ Utilisateur 'vmail' créé."
fi

# 📁 Création du dossier /var/vmail si inexistant
if [ ! -d /var/vmail ]; then
    echo "📁 Création du dossier /var/vmail..."
    sudo mkdir -p /var/vmail
    echo "✅ Dossier /var/vmail créé."
else
    echo "ℹ️  Le dossier /var/vmail existe déjà."
fi

# 🛡️ Vérification des droits du dossier
owner_uid=$(stat -c "%u" /var/vmail)
owner_gid=$(stat -c "%g" /var/vmail)

if [ "$owner_uid" -eq 2000 ] && [ "$owner_gid" -eq 2000 ]; then
    echo "✅ Les droits sur /var/vmail sont déjà corrects (vmail:vmail)."
else
    echo "⚠️  Propriétaire incorrect : $(stat -c "%U:%G" /var/vmail) – application des droits nécessaires..."
    sudo chown -R vmail:vmail /var/vmail
    echo "✅ Droits corrigés : vmail:vmail appliqué à /var/vmail."
fi

echo "✅ Préparation terminée : l'utilisateur 'vmail' et son dossier sont prêts."
