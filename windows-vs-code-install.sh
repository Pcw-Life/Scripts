#!/bin/bash

# Update and Install Required Packages
echo "Updating package list and installing required tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git fzf bash-completion

# Install Oh My Posh
echo "Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash

# Create Oh My Posh Theme Directory
THEME_DIR=~/.poshthemes
mkdir -p $THEME_DIR
chmod u+rw $THEME_DIR

# Download a Sample Oh My Posh Theme
echo "Downloading Oh My Posh theme..."
curl -o $THEME_DIR/sample.omp.json https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/paradox.omp.json
chmod u+rw $THEME_DIR/sample.omp.json

# Set Up Oh My Posh in Bash
echo "Configuring Oh My Posh in Bash..."
if ! grep -q "oh-my-posh" ~/.bashrc; then
    echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/sample.omp.json)"' >> ~/.bashrc
fi

# Configure fzf for Predictive History Search
echo "Configuring fzf for predictive IntelliSense..."
if ! grep -q "__fzf_history_search" ~/.bashrc; then
    cat <<EOL >> ~/.bashrc

# fzf History Search Integration
__fzf_history_search() {
    printf '%s\n' "\$(HISTTIMEFORMAT= history | fzf --height=40% --reverse --border)"
}
bind -x '"\C-r": "__fzf_history_search"'
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
EOL
fi

# Configure ANSI Colors for Bash
echo "Enabling ANSI colors..."
if ! grep -q "LS_COLORS" ~/.bashrc; then
    echo 'export LS_COLORS="di=34:fi=0:ln=36:pi=33:so=35:bd=33:cd=33:or=31:mi=0:ex=32:*.txt=36"' >> ~/.bashrc
fi

# Install Nerd Fonts for Proper Icons
echo "Installing Nerd Fonts..."
NERD_FONT_DIR=~/.fonts
mkdir -p $NERD_FONT_DIR
curl -o $NERD_FONT_DIR/CascadiaCode.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip
unzip -o $NERD_FONT_DIR/CascadiaCode.zip -d $NERD_FONT_DIR
fc-cache -fv

# Install Peacock and Colorize in VS Code
echo "Installing VS Code extensions (Peacock, Colorize, etc.)..."
code --install-extension johnpapa.vscode-peacock
code --install-extension kamikillerto.vscode-colorize
code --install-extension eamodio.gitlens
code --install-extension coenraads.bracket-pair-colorizer-2
code --install-extension streetsidesoftware.code-spell-checker

# Reload Bash Configuration
echo "Reloading Bash configuration..."
source ~/.bashrc

echo "Setup Complete! Restart your terminal and configure VS Code to use a Nerd Font."
