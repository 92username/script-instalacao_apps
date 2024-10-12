#!/bin/bash
# How to use:
# Make it executable:
# $ chmod +x instalacao_apps.sh
# Run the script:
# $ ./instalacao_apps.sh
# At the end, you will receive a list of applications that were not installed correctly
# Make sure to run this script as a user with sudo permissions

# Array to store applications that failed to install
failed_apps=()

# Function to check if the previous command was successful
check_error() {
	if [ $? -ne 0 ]; then
		echo "Error installing $1."
		failed_apps+=("$1")
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

# Check if the environment supports graphical interfaces
if [ -z "$DISPLAY" ]; then
	echo "Error: Graphical environment not detected. Make sure you are in a Linux desktop session."
	exit 1
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
	FALSE "Discord" \
	FALSE "Telegram" \
	FALSE "Visual Studio Code" \
	FALSE "Chromium" \
	FALSE "Firefox" \
	FALSE "Transmission" \
	FALSE "Gdebi" \
	FALSE "Git" \
	FALSE "SSH" \
	FALSE "Virtual Machine Manager" \
	--separator=":")

# Check if the user canceled the selection
if [ -z "$apps" ]; then
	echo "No applications selected. Exiting..."
	exit 1
fi

# Update the system
sudo apt update && sudo apt upgrade -y
check_error "system update"

# Install selected applications
IFS=":" read -r -a selected_apps <<< "$apps"

for app in "${selected_apps[@]}"; do
	echo "Installing $app..."
	case $app in
		"Discord")
			sudo apt install -y discord
			check_error "Discord"
			;;
		"Telegram")
			sudo apt install -y telegram-desktop
			check_error "Telegram"
			;;
		"Visual Studio Code")
			sudo apt install -y wget gpg
			wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
			sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
			sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
			sudo apt update
			sudo apt install -y code
			check_error "Visual Studio Code"
			;;
		"Chromium")
			sudo apt install -y chromium-browser
			check_error "Chromium"
			;;
		"Firefox")
			sudo apt install -y firefox
			check_error "Firefox"
			;;
		"Transmission")
			sudo apt install -y transmission
			check_error "Transmission"
			;;
		"Gdebi")
			sudo apt install -y gdebi-core
			check_error "Gdebi"
			;;
		"Git")
			sudo apt install -y git
			check_error "Git"
			;;
		"SSH")
			sudo apt install -y openssh-client openssh-server
			check_error "SSH"
			;;
		"Virtual Machine Manager")
			sudo apt install -y virt-manager
			check_error "Virtual Machine Manager"
			;;
	esac
done

# Display applications that failed to install
if [ ${#failed_apps[@]} -ne 0 ]; then
	echo "The following applications failed to install:"
	for app in "${failed_apps[@]}"; do
		echo "- $app"
	done
else
	echo "All applications were installed successfully."
fi
