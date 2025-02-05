#!/bin/bash

# --- Fonction pour vérifier si une commande a réussi ---
check_success() {
  if [[ $? -ne 0 ]]; then
    echo "Erreur : $1. Arrêt du script."
    exit 1
  fi
}

# --- Étape 1 : Installer les dépendances nécessaires ---
install_dependencies() {
  echo "Installation des dépendances nécessaires..."
  sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
  check_success "Échec de l'installation des dépendances"
}

# --- Étape 2 : Configuration du proxy ---
configure_proxy() {
  read -p "Votre serveur utilise-t-il un proxy (y/n) ? " proxy_response
  if [[ "$proxy_response" == "y" || "$proxy_response" == "Y" ]]; then
    read -p "Entrez l'adresse du proxy HTTP (ex: http://proxy.exemple.com:8080): " http_proxy
    read -p "Entrez l'adresse du proxy HTTPS (ex: http://proxy.exemple.com:8080): " https_proxy
    export http_proxy=$http_proxy
    export https_proxy=$https_proxy
    export no_proxy="localhost,127.0.0.1"
    echo "Proxy configuré : HTTP=$http_proxy, HTTPS=$https_proxy"
  fi
}

# --- Étape 3 : Ajouter la clé GPG de Docker ---
add_docker_gpg_key() {
  echo "Ajout de la clé GPG de Docker..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  check_success "Impossible d'ajouter la clé GPG de Docker"
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
}

# --- Étape 4 : Ajouter le dépôt Docker ---
add_docker_repository() {
  echo "Ajout du dépôt Docker..."
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  check_success "Impossible d'ajouter le dépôt Docker"
}

# --- Étape 5 : Installer Docker ---
install_docker() {
  echo "Mise à jour des listes de paquets et installation de Docker..."
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  check_success "Échec de l'installation de Docker"
}

# --- Étape 6 : Configurer le proxy pour Docker ---
configure_docker_proxy() {
  if [[ -n "$http_proxy" && -n "$https_proxy" ]]; then
    echo "Configuration du proxy pour Docker..."
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null <<EOL
[Service]
Environment="HTTP_PROXY=$http_proxy"
Environment="HTTPS_PROXY=$https_proxy"
Environment="NO_PROXY=localhost,127.0.0.1"
EOL
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json > /dev/null <<EOL
{
  "http-proxy": "$http_proxy",
  "https-proxy": "$https_proxy",
  "no-proxy": "localhost,127.0.0.1",
  "dns": ["8.8.8.8", "8.8.4.4"]
}
EOL
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    check_success "Échec de la configuration du proxy Docker"
  fi
}

# --- Étape 7 : Vérifier l'installation de Docker ---
verify_docker_installation() {
  echo "Vérification de l'installation de Docker..."
  sudo docker run hello-world
  check_success "Docker n'a pas été installé correctement"
  echo "Docker est opérationnel !"
}

# --- Programme principal ---
install_dependencies
configure_proxy
add_docker_gpg_key
add_docker_repository
install_docker
configure_docker_proxy
verify_docker_installation

echo "Installation et configuration de Docker terminées avec succès !"
