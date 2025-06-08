#!/bin/bash
# install_apps_fedora.sh
# How to use:
# chmod +x install_apps_fedora.sh
# ./install_apps_fedora.sh

start_time=$(date +%s)
echo "Script started at: $(date '+%Y-%m-%d %H:%M:%S')"

failed_apps=()
successful_apps=()
already_installed_apps=()

check_error() {
    if [ $? -ne 0 ]; then
        echo "Error installing $1."
        failed_apps+=("$1")
    else
        successful_apps+=("$1")
    fi
}

is_installed() {
    if command -v "$1" &> /dev/null; then
        echo "$1 is already installed."
        already_installed_apps+=("$2")
        return 0
    else
        return 1
    fi
}

# Check for graphical environment
if [ -z "$DISPLAY" ]; then
    echo "Error: Graphical environment not detected."
    exit 1
fi

# Ensure zenity is installed
if ! command -v zenity &> /dev/null; then
    echo "Zenity not found, installing..."
    sudo dnf install -y zenity
    check_error "Zenity"
fi

# Dialog box
apps=$(zenity --list --checklist --title="Select Applications" --text="Choose the applications to install:" --column="Select" --column="Application" \
    FALSE "Chromium" \
    FALSE "Discord (Flatpak)" \
    FALSE "Docker" \
    FALSE "Firefox" \
    FALSE "GIMP" \
    FALSE "Git" \
    FALSE "SSH Server" \
    FALSE "Telegram (Flatpak)" \
    FALSE "Transmission" \
    FALSE "Virtual Machine Manager" \
    FALSE "Visual Studio Code" \
    FALSE "VLC - Media Player" \
    --separator=":" \
    --width=450 --height=700)

# Check if user canceled
if [ -z "$apps" ]; then
    echo "No applications selected. Exiting..."
    exit 1
fi

# System update
if ! (sudo dnf upgrade -y); then
    echo "Warning: System update encountered issues."
else
    echo "Update successful."
fi

IFS=":" read -r -a selected_apps <<< "$apps"

for app in "${selected_apps[@]}"; do
    echo "Installing $app..."
    case $app in
        "Chromium")
            if ! is_installed chromium "Chromium"; then
                sudo dnf install -y chromium
                check_error "Chromium"
            fi
            ;;
        "Discord (Flatpak)")
            if ! is_installed discord "Discord"; then
                flatpak install -y flathub com.discordapp.Discord
                check_error "Discord"
            fi
            ;;
        "Docker")
            if ! is_installed docker "Docker"; then
                sudo dnf install -y dnf-plugins-core
                sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                sudo systemctl enable --now docker
                sudo usermod -aG docker "$USER"
                echo "⚠️  To use Docker without sudo, please log out and log in again so that group changes take effect."
                check_error "Docker"
            fi
            ;;
        "Firefox")
            if ! is_installed firefox "Firefox"; then
                sudo dnf install -y firefox
                check_error "Firefox"
            fi
            ;;
        "GIMP")
            if ! is_installed gimp "GIMP"; then
                sudo dnf install -y gimp
                check_error "GIMP"
            fi
            ;;
        "Git")
            if ! is_installed git "Git"; then
                sudo dnf install -y git
                check_error "Git"
            fi
            ;;
        "SSH Server")
            if ! is_installed sshd "SSH Server"; then
                sudo dnf install -y openssh-server
                sudo systemctl enable --now sshd
                check_error "SSH Server"
            fi
            ;;
        "Telegram (Flatpak)")
            if ! is_installed telegram-desktop "Telegram"; then
                flatpak install -y flathub org.telegram.desktop
                check_error "Telegram"
            fi
            ;;
        "Transmission")
            if ! is_installed transmission-gtk "Transmission"; then
                sudo dnf install -y transmission
                check_error "Transmission"
            fi
            ;;
        "Virtual Machine Manager")
            if ! is_installed virt-manager "Virtual Machine Manager"; then
                sudo dnf install -y virt-manager
                check_error "Virtual Machine Manager"
            fi
            ;;
        "Visual Studio Code")
            if ! is_installed code "Visual Studio Code"; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
                sudo dnf check-update
                sudo dnf install -y code
                check_error "Visual Studio Code"
            fi
            ;;
        "VLC - Media Player")
            if ! is_installed vlc "VLC - Media Player"; then
                sudo dnf install -y vlc
                check_error "VLC - Media Player"
            fi
            ;;
        *)
            echo "Error: $app is not a valid application."
            ;;
    esac
done

# Clean up
echo "Removing unused packages..."
sudo dnf autoremove -y
echo "System cleanup completed."

# Summary
end_time=$(date +%s)
total_seconds=$((end_time - start_time))
minutes=$((total_seconds / 60))
seconds=$((total_seconds % 60))

echo ""
echo "=================================================="
echo "              INSTALLATION SUMMARY                 "
echo "=================================================="
echo ""

if [ ${#successful_apps[@]} -ne 0 ]; then
    echo "✅ Successfully Installed Applications:"
    for app in "${successful_apps[@]}"; do
        echo "  - $app"
    done
    echo ""
fi

if [ ${#already_installed_apps[@]} -ne 0 ]; then
    echo "ℹ️ Applications Already Installed:"
    for app in "${already_installed_apps[@]}"; do
        echo "  - $app"
    done
    echo ""
fi

if [ ${#failed_apps[@]} -ne 0 ]; then
    echo "❌ Applications That Failed to Install:"
    for app in "${failed_apps[@]}"; do
        echo "  - $app"
    done
    echo ""
fi

echo "⏱️ Total elapsed time: $minutes minutes and $seconds seconds"
echo ""
echo "=================================================="
echo "Installation process completed at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=================================================="
