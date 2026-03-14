#!/bin/bash
# ================================================================
# HyprFlux-Simple: Reapply Configurations
# Updates config files from repo without reinstalling packages
# Useful for pulling latest changes or fixing configuration issues
# ================================================================

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[*]${NC} $@"; }
log_success() { echo -e "${GREEN}[✓]${NC} $@"; }
log_warn() { echo -e "${YELLOW}[!]${NC} $@"; }
log_error() { echo -e "${RED}[✗]${NC} $@"; }

# Find repo directory
if [[ -f "install.sh" ]]; then
    REPO_DIR="$(pwd)"
elif [[ -f "$HOME/.config/hyprflux/repo/install.sh" ]]; then
    REPO_DIR="$HOME/.config/hyprflux/repo"
else
    log_error "Could not find HyprFlux repository"
    exit 1
fi

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║  HyprFlux-Simple: Reapply Configs       ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

log_info "Repository: $REPO_DIR"
echo ""

# Backup first
log_warn "Creating backup before reapplying configs..."
"$REPO_DIR/scripts/backup-user-changes.sh"
echo ""

# Reapply configs
log_info "Reapplying configurations from repository..."

log_info "Copying .config..."
cp -r "$REPO_DIR/.config"/* "$HOME/.config/" 2>/dev/null
log_success ".config updated"

log_info "Copying dotfiles..."
cp "$REPO_DIR/.zshrc" "$HOME/.zshrc"
cp "$REPO_DIR/.tmux.conf" "$HOME/.tmux.conf"
log_success "Dotfiles updated"

if [[ -d "$REPO_DIR/.tmuxifier" ]]; then
    cp -r "$REPO_DIR/.tmuxifier" "$HOME/"
    log_success ".tmuxifier updated"
fi

echo ""
log_success "Configurations reapplied successfully!"
echo ""
log_warn "Note: NeoVim plugins may need manual update"
echo "  Run: nvim --headless \"+Lazy! sync\" \"+qall\""
echo ""
log_warn "Note: After reloading shell, run: tmux source-file ~/.tmux.conf"
echo ""
