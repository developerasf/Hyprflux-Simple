#!/bin/bash
# ================================================================
# HyprFlux-Simple: Validation Script
# Checks if installation was successful and all essential
# components are in place
# ================================================================

set -u

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

checks_passed=0
checks_total=0
issues=()

log_check() {
    local status=$1
    local message=$2
    ((checks_total++))
    
    if [[ "$status" == "PASS" ]]; then
        echo -e "${GREEN}[✓]${NC} $message"
        ((checks_passed++))
    elif [[ "$status" == "WARN" ]]; then
        echo -e "${YELLOW}[!]${NC} $message"
    else
        echo -e "${RED}[✗]${NC} $message"
        issues+=("$message")
    fi
}

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║  HyprFlux-Simple: Validation Report     ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo -e "${BLUE}=== System Requirements ===${NC}"

# Check OS
if grep -qi "arch" /etc/os-release; then
    log_check "PASS" "Arch Linux detected"
else
    log_check "FAIL" "Not on Arch Linux"
fi

# Check sudo
if sudo -n true 2>/dev/null; then
    log_check "PASS" "Sudo access available"
else
    log_check "WARN" "Sudo access requires password (non-critical)"
fi

echo -e "\n${BLUE}=== Desktop Environment ===${NC}"

# Check Hyprland
if command -v Hyprland &>/dev/null; then
    log_check "PASS" "Hyprland installed"
else
    log_check "FAIL" "Hyprland not found"
fi

# Check essential DE packages
for pkg in rofi waybar hyprlock hypridle swww; do
    if command -v "$pkg" &>/dev/null || pacman -Q "$pkg" &>/dev/null 2>&1; then
        log_check "PASS" "$pkg installed"
    else
        log_check "FAIL" "$pkg not installed"
    fi
done

echo -e "\n${BLUE}=== Terminals ===${NC}"

# Check terminals
for term in kitty foot ghostty; do
    if command -v "$term" &>/dev/null; then
        log_check "PASS" "$term installed"
    else
        log_check "WARN" "$term not installed (optional)"
    fi
done

echo -e "\n${BLUE}=== Development Tools ===${NC}"

# Check dev tools
for tool in neovim tmux git docker; do
    if command -v "$tool" &>/dev/null || command -v nvim &>/dev/null; then
        log_check "PASS" "$tool installed"
    else
        log_check "WARN" "$tool not installed"
    fi
done

echo -e "\n${BLUE}=== Configurations ===${NC}"

# Check config directories
for config in hypr waybar rofi kitty tmux; do
    config_dir="$HOME/.config/$config"
    if [[ -d "$config_dir" ]]; then
        log_check "PASS" "\$HOME/.config/$config exists"
    else
        log_check "FAIL" "\$HOME/.config/$config missing"
    fi
done

# Check dotfiles
for dotfile in .zshrc .tmux.conf; do
    if [[ -f "$HOME/$dotfile" ]]; then
        log_check "PASS" "$dotfile deployed"
    else
        log_check "WARN" "$dotfile not deployed"
    fi
done

echo -e "\n${BLUE}=== SDDM Theme ===${NC}"

if [[ -d "/usr/share/sddm/themes/simple-sddm-2" ]]; then
    log_check "PASS" "SDDM theme installed"
else
    log_check "WARN" "SDDM theme not found (login screen will use default)"
fi

echo -e "\n${BLUE}=== Fonts & Theming ===${NC}"

# Check fonts
if fc-list | grep -q "Noto"; then
    log_check "PASS" "Noto fonts installed"
else
    log_check "WARN" "Noto fonts not found"
fi

if fc-list | grep -q "JetBrains Mono"; then
    log_check "PASS" "JetBrains Mono installed"
else
    log_check "WARN" "JetBrains Mono not found"
fi

# Check cursor theme
if [[ -d "$HOME/.icons/Bibata-Modern-Classic" ]] || [[ -d "/usr/share/icons/Bibata-Modern-Classic" ]]; then
    log_check "PASS" "Bibata cursor theme installed"
else
    log_check "WARN" "Bibata cursor not found"
fi

# Check icon theme
if pacman -Q papirus-icon-theme &>/dev/null 2>&1; then
    log_check "PASS" "Papirus icons installed"
else
    log_check "WARN" "Papirus icons not installed"
fi

echo -e "\n${BLUE}=== Web Applications ===${NC}"

# Check web app shortcuts
webapp_count=$(ls -1 "$HOME/.local/share/applications/"*webapp* 2>/dev/null | wc -l)
if [[ $webapp_count -gt 0 ]]; then
    log_check "PASS" "$webapp_count web app shortcuts created"
else
    log_check "WARN" "No web app shortcuts found"
fi

echo -e "\n${BLUE}=== Tmux Plugins ===${NC}"

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    log_check "PASS" "TPM (Tmux Plugin Manager) installed"
else
    log_check "WARN" "TPM not installed"
fi

echo -e "\n${BLUE}=== Package Manager ===${NC}"

if command -v yay &>/dev/null; then
    log_check "PASS" "yay AUR helper installed"
else
    log_check "WARN" "yay not installed (needed for AUR packages)"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "Results: ${GREEN}$checks_passed / $checks_total${NC} checks passed"
echo -e "${BLUE}════════════════════════════════════════${NC}"

if [[ ${#issues[@]} -gt 0 ]]; then
    echo -e "\n${RED}Issues found:${NC}"
    for issue in "${issues[@]}"; do
        echo -e "  ${RED}•${NC} $issue"
    done
    echo ""
    exit 1
else
    echo -e "\n${GREEN}No critical issues found!${NC}"
    exit 0
fi
