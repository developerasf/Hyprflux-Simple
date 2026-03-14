#!/bin/bash
# ================================================================
# HyprFlux-Simple: Unified Installation & Configuration Script
# ================================================================
# Installs Hyprland desktop environment with minimal, stable config
# Bundles: NeoVim, SDDM theme, all dotfiles, web apps
# Zero complexity, one-command deploy

set -euo pipefail

# ================================================================
# COLORS & LOGGING
# ================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

LOG_DIR="$HOME/.config/hyprflux"
LOG_FILE="$LOG_DIR/install.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "$LOG_FILE"
}

info() { echo -e "${BLUE}[*]${NC} $@"; log "INFO" "$@"; }
success() { echo -e "${GREEN}[✓]${NC} $@"; log "SUCCESS" "$@"; }
warn() { echo -e "${YELLOW}[!]${NC} $@"; log "WARN" "$@"; }
error() { echo -e "${RED}[✗]${NC} $@"; log "ERROR" "$@"; }

# ================================================================
# STAGE 1: PRE-FLIGHT CHECKS
# ================================================================

check_os() {
    info "Checking OS compatibility..."
    if ! grep -qi "arch" /etc/os-release 2>/dev/null; then
        error "This script requires Arch Linux or derivatives (Manjaro, EndeavourOS, etc.)"
        exit 1
    fi
    success "OS check passed"
}

check_sudo() {
    info "Checking sudo access..."
    if ! sudo -n true 2>/dev/null; then
        error "Sudo access required. Please run with sudo or ensure sudo is configured for passwordless execution"
        exit 1
    fi
    success "Sudo access confirmed"
}

# ================================================================
# STAGE 2: SYSTEM UPDATES & BOOTSTRAP
# ================================================================

update_system() {
    info "Updating package database..."
    sudo pacman -Sy --noconfirm 2>&1 | tail -5 >> "$LOG_FILE"
    success "System updated"
}

install_essentials() {
    info "Installing essential tools (git, curl, base-devel)..."
    local essentials=("git" "curl" "base-devel")
    for pkg in "${essentials[@]}"; do
        if ! sudo pacman -Q "$pkg" &>/dev/null; then
            sudo pacman -S "$pkg" --noconfirm 2>&1 | tail -3 >> "$LOG_FILE"
            success "Installed $pkg"
        else
            info "$pkg already installed"
        fi
    done
}

# ================================================================
# STAGE 3: DETERMINE REPO LOCATION
# ================================================================

find_repo() {
    info "Determining repository location..."
    
    # If run as curl pipe, we need to clone the repo
    if [[ ! -f "install.sh" ]]; then
        local repo_url="${HYPRFLUX_REPO:-https://github.com/yourusername/hyprflux-simple.git}"
        local repo_dir="${HOME}/.config/hyprflux/repo"
        
        info "Cloning repository to ${repo_dir}..."
        if [[ -d "$repo_dir" ]]; then
            cd "$repo_dir" && git pull --quiet origin main 2>&1 >> "$LOG_FILE"
            success "Repository updated"
        else
            mkdir -p "$repo_dir"
            git clone --quiet "$repo_url" "$repo_dir" 2>&1 >> "$LOG_FILE"
            success "Repository cloned"
        fi
        
        cd "$repo_dir"
        REPO_DIR="$repo_dir"
    else
        REPO_DIR="$(pwd)"
        success "Using local repository: $REPO_DIR"
    fi
}

# ================================================================
# STAGE 4: INSTALL PACKAGES
# ================================================================

install_packages() {
    info "Installing packages from packages.txt..."
    
    local pacman_packages=()
    local aur_packages=()
    
    # Parse packages.txt
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue
        
        # Check if in AUR section
        if [[ "$line" =~ ^.*AUR\ PACKAGES ]] || [[ "$in_aur" == "1" ]]; then
            if [[ "$line" =~ ^.*AUR\ PACKAGES ]]; then
                in_aur=1
                continue
            fi
            aur_packages+=("$line")
        else
            pacman_packages+=("$line")
        fi
    done < "$REPO_DIR/packages.txt"
    
    # Install pacman packages
    info "Installing pacman packages (${#pacman_packages[@]} packages)..."
    for pkg in "${pacman_packages[@]}"; do
        if sudo pacman -Q "$pkg" &>/dev/null 2>&1; then
            info "$pkg already installed"
        else
            local attempt=1
            while [[ $attempt -le 3 ]]; do
                if sudo pacman -S "$pkg" --noconfirm 2>&1 | tail -2 >> "$LOG_FILE"; then
                    success "✓ $pkg"
                    break
                else
                    if [[ $attempt -eq 3 ]]; then
                        warn "Failed to install $pkg after 3 attempts (continuing...)"
                    else
                        warn "Retrying $pkg (attempt $((attempt + 1))/3)..."
                    fi
                fi
                ((attempt++))
            done
        fi
    done
    success "Pacman package installation complete"
    
    # Install AUR packages (if yay is available)
    if command -v yay &>/dev/null; then
        info "Installing AUR packages (${#aur_packages[@]} packages)..."
        for pkg in "${aur_packages[@]}"; do
            if yay -Q "$pkg" &>/dev/null 2>&1; then
                info "$pkg already installed"
            else
                warn "Installing AUR package: $pkg (may require interaction)"
                yay -S "$pkg" --noconfirm 2>&1 | tail -2 >> "$LOG_FILE" || warn "Failed to install $pkg"
            fi
        done
        success "AUR package installation complete"
    else
        warn "yay not found. Skipping AUR packages. Install yay to get: ${aur_packages[@]}"
    fi
}

# ================================================================
# STAGE 5: BACKUP EXISTING CONFIGS
# ================================================================

backup_configs() {
    info "Backing up existing configurations..."
    
    local backup_dir="${HOME}/hyprflux-backup-$(date +%s)"
    local backed_up=0
    
    for item in .config .zshrc .tmux.conf; do
        if [[ -e "$HOME/$item" ]]; then
            mkdir -p "$backup_dir"
            cp -r "$HOME/$item" "$backup_dir/" 2>&1 >> "$LOG_FILE"
            ((backed_up++))
        fi
    done
    
    if [[ $backed_up -gt 0 ]]; then
        success "Backed up $backed_up existing items to: $backup_dir"
    else
        info "No existing configs to backup"
    fi
}

# ================================================================
# STAGE 6: DEPLOY CONFIGURATIONS
# ================================================================

deploy_configs() {
    info "Deploying configurations..."
    
    # Copy .config directory
    cp -r "$REPO_DIR/.config"/* "$HOME/.config/" 2>&1 >> "$LOG_FILE"
    success "✓ .config deployed"
    
    # Copy dotfiles
    cp "$REPO_DIR/.zshrc" "$HOME/.zshrc" 2>&1 >> "$LOG_FILE"
    cp "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf" 2>&1 >> "$LOG_FILE"
    success "✓ .zshrc deployed"
    success "✓ .tmux.conf deployed"
    
    # Copy tmuxifier configs if present
    if [[ -d "$REPO_DIR/.tmuxifier" ]]; then
        cp -r "$REPO_DIR/.tmuxifier" "$HOME/" 2>&1 >> "$LOG_FILE"
        success "✓ .tmuxifier deployed"
    fi
    
    # Create essential directories
    mkdir -p "$HOME/.local/share/applications"
    mkdir -p "$HOME/.config/fontconfig/conf.d"
    
    success "Configuration deployment complete"
}

# ================================================================
# STAGE 7: INSTALL SDDM THEME
# ================================================================

install_sddm_theme() {
    info "Installing SDDM login theme..."
    
    local theme_src="$REPO_DIR/sddm-theme"
    local theme_dest="/usr/share/sddm/themes/simple-sddm-2"
    
    if [[ ! -d "$theme_src" ]]; then
        warn "SDDM theme not found in repository, skipping"
        return
    fi
    
    sudo mkdir -p "$theme_dest"
    sudo cp -r "$theme_src"/* "$theme_dest/" 2>&1 >> "$LOG_FILE"
    success "✓ SDDM theme installed"
    
    # Update SDDM configuration
    if [[ -f /etc/sddm.conf ]]; then
        info "Updating SDDM configuration..."
        sudo tee /etc/sddm.conf > /dev/null <<EOF
[General]
Session=hyprland
Current=simple-sddm-2
EOF
        success "✓ SDDM config updated"
    else
        warn "SDDM config file not found at /etc/sddm.conf"
    fi
}

# ================================================================
# STAGE 8: SETUP NEOVIM
# ================================================================

setup_neovim() {
    info "Setting up NeoVim plugins..."
    
    if ! command -v nvim &>/dev/null; then
        warn "NeoVim not found, skipping plugin setup"
        return
    fi
    
    # Install plugins via Lazy.nvim (if configured)
    nvim --headless "+Lazy! sync" "+Mason" "+qall" 2>&1 | tail -3 >> "$LOG_FILE" || \
        warn "NeoVim plugin sync had issues (check manually)"
    
    success "✓ NeoVim configured"
}

# ================================================================
# STAGE 9: SETUP TMUX
# ================================================================

setup_tmux() {
    info "Setting up Tmux plugin manager..."
    
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    if [[ ! -d "$tpm_dir" ]]; then
        mkdir -p "$HOME/.tmux/plugins"
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir" 2>&1 >> "$LOG_FILE"
        success "✓ TPM installed"
    fi
    
    # Install plugins
    "$tpm_dir/bin/install_plugins" 2>&1 >> "$LOG_FILE" || warn "TPM plugin install had issues"
    
    success "✓ Tmux configured"
}

# ================================================================
# STAGE 10: SETUP ZSH
# ================================================================

setup_zsh() {
    info "Setting up Zsh shell..."
    
    # Change default shell to zsh
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        info "Changing default shell to zsh..."
        chsh -s "$(which zsh)" 2>&1 >> "$LOG_FILE"
        success "✓ Default shell changed to Zsh"
    else
        info "Zsh already set as default shell"
    fi
    
    # Check for Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        warn "Oh My Zsh not installed. Install with: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    else
        success "✓ Oh My Zsh detected"
    fi
    
    success "✓ Zsh configured"
}

# ================================================================
# STAGE 11: INSTALL/UPDATE FONTS
# ================================================================

setup_fonts() {
    info "Configuring fonts..."
    
    local font_conf_dir="$HOME/.config/fontconfig/conf.d"
    mkdir -p "$font_conf_dir"
    
    # Rebuild font cache
    if command -v fc-cache &>/dev/null; then
        fc-cache -fv 2>&1 | tail -2 >> "$LOG_FILE"
        success "✓ Font cache rebuilt"
    fi
    
    success "✓ Fonts configured"
}

# ================================================================
# STAGE 12: SETUP CHROMIUM PWAs
# ================================================================

setup_webapps() {
    info "Setting up Chromium web app shortcuts..."
    
    local webapps_conf="$REPO_DIR/config/webapps.conf"
    
    if [[ ! -f "$webapps_conf" ]]; then
        warn "webapps.conf not found, skipping"
        return
    fi
    
    local app_count=0
    while IFS='|' read -r name url icon_type; do
        # Skip comments
        [[ "$name" =~ ^#.*$ ]] && continue
        [[ -z "$name" ]] && continue
        
        # Create .desktop file for Chromium PWA
        local desktop_file="$HOME/.local/share/applications/${name}-webapp.desktop"
        
        cat > "$desktop_file" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
Exec=chromium --app=$url
Icon=web-chrome
Categories=Utility;
Terminal=false
StartupNotify=true
EOF
        chmod +x "$desktop_file"
        ((app_count++))
        success "✓ ${name} web app shortcut created"
    done < "$webapps_conf"
    
    if [[ $app_count -gt 0 ]]; then
        update-desktop-database "$HOME/.local/share/applications" 2>&1 >> "$LOG_FILE"
        success "Desktop database updated"
    fi
}

# ================================================================
# STAGE 13: SETUP CURSORS & ICONS
# ================================================================

setup_theming() {
    info "Setting up cursor theme and icons..."
    
    # Set cursor theme via gsettings (Hyprland compatible)
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>&1 >> "$LOG_FILE" || \
            warn "Failed to set cursor theme via gsettings"
        success "✓ Cursor theme set"
    fi
    
    # Ensure icon directories exist
    mkdir -p "$HOME/.icons"
    
    success "✓ Theming configured"
}

# ================================================================
# STAGE 14: FINAL VALIDATION & SUMMARY
# ================================================================

final_checks() {
    info "Running final validation checks..."
    
    local checks_passed=0
    local checks_total=0
    
    # Check Hyprland
    ((checks_total++))
    if command -v hyprland &>/dev/null || command -v Hyprland &>/dev/null; then
        success "✓ Hyprland installed"
        ((checks_passed++))
    else
        warn "✗ Hyprland not found"
    fi
    
    # Check essential tools
    for tool in rofi waybar kitty nvim tmux git; do
        ((checks_total++))
        if command -v "$tool" &>/dev/null; then
            success "✓ $tool installed"
            ((checks_passed++))
        else
            warn "✗ $tool not found"
        fi
    done
    
    # Check config directories
    for config in hypr waybar rofi kitty; do
        ((checks_total++))
        if [[ -d "$HOME/.config/$config" ]]; then
            success "✓ .$config config deployed"
            ((checks_passed++))
        else
            warn "✗ .$config config missing"
        fi
    done
    
    echo ""
    info "========================================="
    info "Installation Summary"
    info "========================================="
    echo -e "${GREEN}Passed: $checks_passed / $checks_total checks${NC}"
    echo -e "Log file: ${BLUE}$LOG_FILE${NC}"
    echo ""
    success "HyprFlux-Simple installation complete!"
    echo ""
    info "Next steps:"
    echo "  1. Review/customize: ~/.config/hypr/userconf/"
    echo "  2. Customize Waybar: ~/.config/waybar/"
    echo "  3. Customize Rofi: ~/.config/rofi/"
    echo "  4. (Optional) Install wallpapers: ~/.local/share/hyprland/wallpapers/"
    echo "  5. Reboot to see SDDM theme and full desktop"
    echo ""
}

# ================================================================
# MAIN EXECUTION
# ================================================================

main() {
    clear
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   HyprFlux-Simple Installation          ║"
    echo "║   Hyprland Desktop Environment          ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    info "Starting installation at $(date)"
    echo ""
    
    check_os
    check_sudo
    update_system
    install_essentials
    find_repo
    install_packages
    backup_configs
    deploy_configs
    install_sddm_theme
    setup_neovim
    setup_tmux
    setup_zsh
    setup_fonts
    setup_webapps
    setup_theming
    final_checks
    
    echo ""
    info "Installation finished at $(date)"
    
    # Prompt for reboot
    if [[ "${HYPRFLUX_SKIP_REBOOT:-0}" != "1" ]]; then
        echo ""
        read -p "Reboot now to apply all changes? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            info "Rebooting..."
            sudo reboot
        else
            info "Remember to reboot when ready to see the setup"
        fi
    fi
}

# Handle errors
trap 'error "Installation failed at line $LINENO"; exit 1' ERR

# Run main
main
