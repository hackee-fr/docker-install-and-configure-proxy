# Script Bash d'Installation et de Configuration de Docker

Ce script permet d'installer Docker sur une machine Debian/Ubuntu, avec la prise en charge des configurations de proxy HTTP/HTTPS. Il automatise l'installation de Docker et sa configuration en fonction des paramètres du réseau.

## Prérequis

Avant de lancer ce script, assurez-vous que :

- Vous avez les privilèges `sudo` sur votre machine.
- Vous utilisez une distribution Debian/Ubuntu.
- Vous avez accès à un terminal.
  
Si votre machine utilise un proxy HTTP/HTTPS, le script vous permettra également de configurer Docker pour fonctionner derrière ce proxy.

## Fonctionnement du script

Le script est divisé en plusieurs étapes pour faciliter la configuration et le dépannage :

1. **Installation des dépendances nécessaires** : 
   - Installe les outils nécessaires pour ajouter des dépôts et gérer les clés GPG.

2. **Configuration du proxy** : 
   - Si vous êtes derrière un proxy, il vous sera demandé d'entrer les informations de votre proxy HTTP et HTTPS.

3. **Ajout de la clé GPG de Docker** :
   - Ajoute la clé GPG nécessaire pour sécuriser les paquets Docker.

4. **Ajout du dépôt Docker** :
   - Ajoute le dépôt officiel de Docker à votre gestionnaire de paquets APT.

5. **Installation de Docker** :
   - Installe Docker ainsi que ses composants essentiels (Docker CE, Docker CLI, containerd, etc.).

6. **Configuration du proxy pour Docker** :
   - Si un proxy est configuré, le script configure Docker pour qu'il fonctionne derrière ce proxy.

7. **Vérification de l'installation de Docker** :
   - Lance un test pour vérifier que Docker est bien installé et fonctionne correctement avec la commande `docker run hello-world`.

## Utilisation

### Étape 1 : Téléchargement du script

Téléchargez le script sur votre machine :

```bash
wget <URL_DU_SCRIPT> -O install_docker.sh
```

### Étape 2 : Rendre le script exécutable

Rendez le script exécutable avec la commande suivante :

```bash
chmod +x install_docker.sh
```

### Étape 3 : Exécuter le script

Exécutez le script avec les droits `sudo` pour que l'installation fonctionne correctement :

```bash
sudo ./install_docker.sh
```

Le script vous guidera tout au long du processus, notamment pour la configuration du proxy (si nécessaire).

## Notes

- Si vous ne travaillez pas derrière un proxy, vous pouvez simplement répondre "n" ou "N" lorsqu'on vous demande si vous utilisez un proxy.
- Le script vérifie si chaque étape est réussie. Si une étape échoue, le script s'arrête et affiche un message d'erreur.
- Une fois l'installation terminée, vous pourrez utiliser Docker sur votre machine.

## Troubleshooting

- Si vous rencontrez des problèmes pendant l'installation, consultez les messages d'erreur retournés par le script.
- Si Docker ne fonctionne pas après l'installation, vérifiez que les paramètres de votre proxy sont correctement configurés dans le fichier `/etc/docker/daemon.json`.

## Conclusion

Ce script permet d'automatiser l'installation de Docker et de le configurer en fonction de votre environnement réseau. Il facilite grandement l'installation sur des machines avec des configurations de proxy.
