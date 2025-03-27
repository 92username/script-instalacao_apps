#!/bin/bash
# How to use:
# Make it executable:
# $ chmod +x instalacao_apps.sh
# Run the script:
# $ ./instalacao_apps.sh
# At the end, you will receive a list of applications that were not installed correctly
# Make sure to run this script as a user with sudo permissions

# Arrays to store installation outcomes
failed_apps=()
successful_apps=()
already_installed_apps=()

# Function to check if the previous command was successful
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error installing $1."
        failed_apps+=("$1")
        return 1
    else
        successful_apps+=("$1")
        return 0
    fi
}

# Function to check if an application is already installed
is_installed() {
    if command -v "$1" &> /dev/null; then
        echo "$1 is already installed."
        already_installed_apps+=("$2")
        return 0
    else
        return 1
    fi
}

# Check if the environment supports graphical interfaces
if [ -z "$DISPLAY" ]; then
    echo "Error: Graphical environment not detected. Make sure you are in a Linux desktop session."
    exit 1
fi

# Install dbus-x11 if not installed
if ! command -v dbus-launch &> /dev/null; then
    echo "dbus-x11 not found, installing..."
    sudo apt-get update && sudo apt-get install -y dbus-x11
fi

# Install zenity if not installed
if ! command -v zenity &> /dev/null; then
    echo "Zenity not found, installing..."
    sudo apt install -y zenity
    check_error "Zenity"
fi

# Dialog box to select applications
echo "Opening zenity dialog box..."
apps=$(zenity --list --checklist --title="Select Applications" --text="Choose the applications to install:" --column="Select" --column="Application" \
    FALSE "Chromium" \
    FALSE "Discord (snap)" \
    FALSE "Firefox" \
    FALSE "Gdebi" \
    FALSE "GIMP" \
    FALSE "Git" \
    FALSE "SSH" \
    FALSE "Telegram (snap)" \
    FALSE "Transmission" \
    FALSE "Virtual Machine Manager" \
    FALSE "Visual Studio Code" \
    FALSE "VLC - Media Player" \
    --separator=":" \
    --width=450 --height=700)

# Check if the user canceled the selection
if [ -z "$apps" ]; then
    echo "No applications selected. Exiting..."
    exit 1
fi

# Update the system
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Warning: System update encountered issues."
else
    echo "System updated successfully."
fi

# Install selected applications
IFS=":" read -r -a selected_apps <<< "$apps"

for app in "${selected_apps[@]}"; do
    echo "Installing $app..."
    case $app in
        "Discord (snap)")
            if ! is_installed discord "Discord"; then
                # Check if snap is installed, if not install it
                if ! command -v snap &> /dev/null; then
                    echo "snap not found, installing..."
                    sudo apt install -y snapd
                    sudo systemctl enable --now snapd.socket
                    sleep 2
                fi
                echo "Installing Discord via snap..."
                sudo snap install discord
                check_error "Discord"
            fi
            ;;
        "GIMP")
            if ! is_installed gimp "GIMP"; then
                echo "Installing GIMP..."
                sudo apt install -y gimp
                check_error "GIMP"
            fi            
            ;;
        "Telegram (snap)")
            if ! is_installed telegram-desktop "Telegram"; then
                echo "Installing Telegram via snap..."
                sudo snap install telegram-desktop
                check_error "Telegram"
            fi
            ;;
        "Visual Studio Code")
            if ! is_installed code "Visual Studio Code"; then
                sudo apt install -y wget gpg
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
                sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
                sudo apt update
                sudo apt install -y code
                check_error "Visual Studio Code"
            fi
            ;;
        "Chromium")
            if ! is_installed chromium-browser "Chromium"; then
                sudo apt install -y chromium-browser
                check_error "Chromium"
            fi
            ;;
        "Firefox")
            if ! is_installed firefox "Firefox"; then
                sudo apt install -y firefox
                check_error "Firefox"
            fi
            ;;
        "Transmission")
            if ! is_installed transmission-gtk "Transmission"; then
                sudo apt install -y transmission
                check_error "Transmission"
            fi
            ;;
        "Gdebi")
            if ! is_installed gdebi "Gdebi"; then
                sudo apt install -y gdebi-core
                check_error "Gdebi"
            fi
            ;;
        "Git")
            if ! is_installed git "Git"; then
                sudo apt install -y git
                check_error "Git"
            fi
            ;;
        "SSH")
            if ! is_installed ssh "SSH"; then
                sudo apt install -y openssh-client openssh-server
                check_error "SSH"
            fi
            ;;
        "Virtual Machine Manager")
            if ! is_installed virt-manager "Virtual Machine Manager"; then
                sudo apt install -y virt-manager
                check_error "Virtual Machine Manager"
            fi
            ;;
        "VLC - Media Player")
            if ! is_installed vlc "VLC - Media Player"; then
                sudo apt install -y vlc
                check_error "VLC - Media Player"
            fi
            ;;
        *)
            echo "Error: $app is not a valid application."
            ;;
    esac
done

# Display installation summary
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

# Final status message
echo "=================================================="
echo "Installation process completed."
echo "=================================================="