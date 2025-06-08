[![CI](https://github.com/92username/script-instalacao_apps/actions/workflows/blank.yml/badge.svg)](https://github.com/92username/script-instalacao_apps/actions/workflows/blank.yml)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/1f8de1acb23d4669a372247229de2036)](https://app.codacy.com/gh/92username/script-instalacao_apps/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

# App Installation Script

This is an **automated script** for installing essential applications on Linux systems, designed to streamline the initial setup of a machine. The goal is to offer a simple and modular solution that can be expanded over time, incorporating new features like a **graphical dialog interface** for easier use.

## Project Goal

This project was created to automate the installation of common software on Linux, speeding up the process of setting up a new machine. We aim to make it a starting point for more people to collaborate, adding new features and customizations.

### Current Features

- Automatic installation of various applications via terminal.
- Quick and easy setup on Linux-based systems (e.g., Ubuntu, Mint, Fedora).
- Modularity: Add and remove applications directly in the script.
- **Support for multiple Linux distributions** (Ubuntu/Mint and Fedora).

![Screenshot do aplicativo](/screenshot_app.png)

### Future Features (Under Development)

- [x] Graphical interface for selecting applications to install (graphical dialog box).
- [ ] Support for more Linux distributions.
- [x] Code optimizations for greater flexibility and customization.

## How to Use

### Prerequisites

To use these scripts, you need a Linux system with `bash` and **superuser** (root) privileges.

### Installation Instructions

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/92username/script-instalacao_apps.git
   ```
2. Navigate to the project directory:
   ```bash
   cd script-instalacao_apps
   ```
3. Make the desired script executable:
   - For Ubuntu/Mint:
     ```bash
     chmod +x install_apps_ubuntu.sh
     ```
   - For Fedora:
     ```bash
     chmod +x install_apps_fedora.sh
     ```
4. Run the appropriate script as a superuser:
   - For Ubuntu/Mint:
     ```bash
     sudo ./install_apps_ubuntu.sh
     ```
   - For Fedora:
     ```bash
     sudo ./install_apps_fedora.sh
     ```
5. The script will automatically install all the applications listed for your distribution.

### Customization

If you want to add or remove applications from the list, simply edit the corresponding script file (`install_apps_ubuntu.sh` or `install_apps_fedora.sh`) and modify the package list in the appropriate section.

### Example Code for adding a new application

   ```bash
      sudo apt install application-name
   ```
   or, for Fedora:
   ```bash
      sudo dnf install application-name
   ```

## Contributions

Contributions are welcome! If you have suggestions, find a bug, or want to work on a new feature, follow the steps below:

1. **Fork** the repository.
2. Create a new branch for your changes: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push to the main branch: `git push origin my-new-feature`.
5. Open a **Pull Request**.

## License

This project is licensed under the GNU License - see the [LICENSE](LICENSE) file for details.
