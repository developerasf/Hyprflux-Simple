#!/bin/bash
# ================================================================
# HyprFlux-Simple: User Changes Backup Utility
# Creates a backup of user modifications made after initial install
# Useful before re-running install script or troubleshooting
# ================================================================

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

backup_dir="$HOME/hyprflux-changes-backup-$(date +%Y%m%d_%H%M%S)"
configs_to_backup=(
    ".config"
    ".zshrc"
    ".tmux.conf"
    ".oh-my-zsh"
    ".local/share/applications"
)

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║  HyprFlux-Simple: User Changes Backup   ║"
echo "╚════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

info() { echo -e "${BLUE}[*]${NC} $@"; }
success() { echo -e "${GREEN}[✓]${NC} $@"; }
warn() { echo -e "${YELLOW}[!]${NC} $@"; }

info "Creating backup of user configurations..."
mkdir -p "$backup_dir"

backed_up=0
for item in "${configs_to_backup[@]}"; do
    full_path="$HOME/$item"
    if [[ -e "$full_path" ]]; then
        cp -r "$full_path" "$backup_dir/" 2>/dev/null
        ((backed_up++))
        success "Backed up: $item"
    fi
done

if [[ $backed_up -gt 0 ]]; then
    success ""
    success "Backup created successfully!"
    echo ""
    echo -e "Location: ${BLUE}$backup_dir${NC}"
    echo ""
    info "To restore from this backup later:"
    echo "  cp -r '$backup_dir/'* ~/"
    echo ""
    info "Backup size:"
    du -sh "$backup_dir"
else
    warn "No user configurations found to backup"
    rmdir "$backup_dir"
fi
