#!/bin/bash
# Como usar:
# Torne-o executavel:
# $ chmod +x instalacao_apps.sh
# Execute o script:
# ./instalacao_apps.sh
# No final voce recebera uma lista dos aplicativos que não foram instalados corretamente


# Array para armazenar os aplicativos que falharam na instalação
failed_apps=()

# Função para verificar se o comando anterior foi bem-sucedido
check_error() {
    if [ $? -ne 0 ]; then
        echo "Erro na instalação de $1."
        failed_apps+=("$1")
    fi
}

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y
check_error "atualização do sistema"

# Instalar Discord
sudo apt install -y discord
check_error "Discord"

# Instalar Telegram
sudo apt install -y telegram-desktop
check_error "Telegram"

# Instalar Visual Studio Code
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
check_error "Visual Studio Code"

# Instalar Chromium
sudo apt install -y chromium-browser
check_error "Chromium"

# Instalar Firefox
sudo apt install -y firefox
check_error "Firefox"

# Instalar Transmission
sudo apt install -y transmission
check_error "Transmission"

#Intalar gdebi / The `gdebi` is a useful tool for installing `.deb` packages and automatically resolves the necessary dependencies.

sudo apt install gdebi-core
check_error "gdebi"

# Instalação do Git
sudo apt update
sudo apt install -y git
check_error "git"

# Instalação do SSH
sudo apt install -y openssh-client openssh-server
check_error "SSH"


# Verificar se houve falhas
if [ ${#failed_apps[@]} -eq 0 ]; then
    echo "Todos os aplicativos foram instalados com sucesso!"
else
    echo "Os seguintes aplicativos falharam na instalação:"
    for app in "${failed_apps[@]}"; do
        echo "- $app"
    done
fi
