#!/bin/bash

# Install PowerShell if not already installed
if ! command -v pwsh &> /dev/null
then
    echo "PowerShell not found. Installing PowerShell..."
    brew install --cask powershell
fi

# Install Oh My Posh if not already installed
if ! command -v oh-my-posh &> /dev/null
then
    echo "Oh My Posh not found. Installing Oh My Posh..."
    brew install oh-my-posh
fi

# Create the PowerShell profile directory if it doesn't exist
PROFILE_DIR="$HOME/.config/powershell"
mkdir -p "$PROFILE_DIR"

# Download the `jandedobbeleer.omp.json` theme file
echo "Downloading Oh My Posh theme..."
curl -o "$PROFILE_DIR/jandedobbeleer.omp.json" https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/jandedobbeleer.omp.json

# Write the PowerShell Profile to Configure Oh My Posh
echo "Setting up PowerShell profile..."

cat <<EOF > "$PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
# Import Oh My Posh theme
Import-Module oh-my-posh

# Load the theme
Set-PoshPrompt -Theme $PROFILE_DIR/jandedobbeleer.omp.json

# Additional PowerShell Customizations
# Alias: Using exa instead of ls for better directory listings (similar to Hanselman's setup)
if (Get-Command exa -ErrorAction SilentlyContinue) {
    Set-Alias ls exa
}

# Function to Show Git Status in the Prompt (optional but adds more info)
function prompt {
    \$status = Get-OhMyPoshTheme
    Write-Host \$status
}

# Set Fonts and Appearance
Set-PSReadlineOption -Colors @{
    Command            = [ConsoleColor]::Cyan
    String             = [ConsoleColor]::DarkYellow
    Operator           = [ConsoleColor]::Gray
    Variable           = [ConsoleColor]::Green
    Parameter          = [ConsoleColor]::Magenta
    Type               = [ConsoleColor]::Blue
    InlinePrediction   = [ConsoleColor]::DarkGray
}
EOF

# Install Additional Modules (optional but recommended)
echo "Installing additional PowerShell modules..."
pwsh -Command "Install-Module PSReadLine -Scope CurrentUser -Force"
pwsh -Command "Install-Module oh-my-posh -Scope CurrentUser -Force"

echo "Setup complete. Please start PowerShell using 'pwsh' or launch the app from your applications."