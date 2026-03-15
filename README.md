# HyprFlux-Simple

A **minimal, stable, and production-ready** Hyprland desktop environment dotfiles bundle. Everything you need to go from fresh Arch Linux to a beautiful, functional Hyprland setup in one command.

**Aesthetics**: Catppuccin Mocha | **Compositor**: Hyprland | **Shell**: Zsh + Starship | **Editor**: NeoVim | **Terminal**: Kitty

---

## ✨ What's Included

- **Hyprland** - Modern Wayland compositor with smooth animations
- **Rofi** - Fast, lightweight app launcher with custom themes
- **Waybar** - Customizable system bar with network, audio, brightness controls
- **Kitty** - GPU-accelerated terminal emulator
- **NeoVim** - Pre-configured with Lazy plugins and Mason LSP setup
- **Tmux** - Terminal multiplexer with TPM (plugin manager)
- **Zsh** - Shell with Oh My Zsh and Starship prompt
- **SDDM Simple Theme** - Elegant login screen
- **Chromium PWAs** - WhatsApp, Telegram, Teams, Office365 as desktop apps
- **50+ System Packages** - From file managers to development tools
- **3 AUR Packages** - sunshine-bin, brave-bin, localsend-bin (optional)

---

## 🎯 Quick Start

### Option 1: Fresh Arch Installation
```bash
# Run this on fresh Arch Linux (requires sudo)
curl -O https://raw.githubusercontent.com/developerasf/hyprflux-simple/main/install.sh && bash install.sh
```

### Option 2: Local Installation
```bash
git clone https://github.com/developerasf/hyprflux-simple.git
cd hyprflux-simple
bash install.sh
```

### Option 3: Dry Run (Validate without installing)
```bash
bash install.sh --dry-run
```

---

## 📋 Prerequisites

- **Arch Linux** or derivatives (Manjaro, EndeavourOS, etc.)
- **sudo** access (for package installation and system config)
- **Internet connection** (to download packages)
- **~2GB free disk space**

**Not required but helpful**:
- `yay` for AUR packages (script attempts auto-install)
- Existing ~/.config/ will be backed up automatically

---

## 🚀 Installation Stages

The `install.sh` runs these stages (can take 10-20 minutes depending on internet):

1. **OS & Sudo Checks** - Validates Arch Linux and sudo access
2. **System Updates** - `pacman -Sy` (package database update)
3. **Repository Setup** - Clones repo if needed (from curl-pipe execution)
4. **Package Installation** - Installs 50+ pacman packages + 3 AUR packages
5. **Config Backup** - Backs up existing ~/.config/ to ~/hyprflux-backup-TIMESTAMP/
6. **Config Deployment** - Copies all dotfiles, configs, themes
7. **SDDM Theme Setup** - Installs login screen theme
8. **NeoVim Setup** - Installs plugins via Lazy.nvim + LSP via Mason
9. **Tmux Setup** - Installs TPM and plugins
10. **Zsh Setup** - Sets Zsh as default shell (requires Oh My Zsh installed separately)
11. **Font Configuration** - Rebuilds font cache
12. **Chromium Web Apps** - Creates .desktop files for WhatsApp, Telegram, Teams, Office365
13. **Cursor & Icons** - Sets Bibata cursor and validates Papirus icons
14. **Final Validation** - Checks all components installed correctly
15. **Reboot Prompt** - Asks to reboot (optional)

---

## 📁 File Structure

```
hyprflux-simple/
├── install.sh                   # Main installation script
├── packages.txt                 # Package list (pacman + AUR)
├── README.md                    # This file
├── LICENSE                      # License file
├── .gitignore                   # Git ignore rules
│
├── .config/                     # All desktop configurations
│   ├── hypr/                    # Hyprland compositor config
│   │   ├── hyprland.conf       # Main config
│   │   ├── UserConfigs/        # User customization folder
│   │   └── ...
│   ├── waybar/                  # System bar config & styling
│   ├── rofi/                    # App launcher themes
│   ├── kitty/                   # Terminal emulator config
│   ├── nvim/                    # NeoVim config (bundled)
│   ├── foot/                    # Alternative terminal
│   ├── ghostty/                 # Another terminal option
│   ├── swaync/                  # Notification daemon
│   ├── cava/                    # Audio visualizer
│   ├── fastfetch/              # System info tool
│   ├── yazi/                    # File manager
│   ├── qt5ct/                   # Qt5 theme settings
│   ├── qt6ct/                   # Qt6 theme settings
│   └── mimeapps.list           # Default app associations
│
├── .zshrc                       # Zsh shell configuration
├── .tmux.conf                   # Tmux multiplexer config
├── .tmuxifier/                  # Tmux session layouts
│
├── sddm-theme/                  # SDDM login screen theme
│   ├── Main.qml                # QML UI
│   ├── Components/             # UI components
│   ├── Assets/                 # Images & icons
│   ├── Backgrounds/            # Background images
│   ├── theme.conf              # Theme settings
│   └── metadata.desktop        # Theme metadata
│
├── wallpapers/                  # Default wallpapers
│   └── (user-provided images)
│
├── config/                      # Configuration files
│   └── webapps.conf            # Chromium PWA definitions
│
└── scripts/                     # Utility scripts
    ├── validate.sh             # Check installation success
    ├── backup-user-changes.sh  # Backup your customizations
    └── reapply-configs.sh      # Update configs from repo
```

---

## ⚙️ Configuration & Customization

### Hyprland Configuration
Edit your Hyprland settings without losing them on reinstall:

```bash
# User customization folder (auto-sourced by hyprland.conf)
~/.config/hypr/UserConfigs/

# Edit keybinds, monitors, workspace rules, etc.
~/.config/hypr/UserConfigs/keybinds.conf
~/.config/hypr/UserConfigs/windowrules.conf
~/.config/hypr/UserConfigs/monitors.conf
```

### Waybar Configuration
```bash
# Layout and widgets
~/.config/waybar/config.jsonc

# Styling (Catppuccin Mocha)
~/.config/waybar/style.css
```

### Rofi Configuration
```bash
# App launcher theme
~/.config/rofi/config.rasi

# Additional themes
~/.config/rofi/config-*.rasi
```

### NeoVim Configuration
```bash
# Lazy.nvim entry point
~/.config/nvim/init.lua

# Plugin specs
~/.config/nvim/lua/plugins/

# Install/update plugins:
nvim --headless "+Lazy! sync" "+qall"
```

### Tmux Configuration
```bash
# Main config
~/.tmux.conf

# Session layouts
~/.tmuxifier/layouts/

# Reload after editing:
tmux source-file ~/.tmux.conf
```

### Zsh Configuration
```bash
# Shell config
~/.zshrc

# Starship prompt
~/.config/starship.toml
```

### Web Apps Configuration
```bash
# Add/remove Chromium PWAs
~/hyprflux-simple/config/webapps.conf

# Reapply to generate new .desktop files
bash ~/hyprflux-simple/scripts/reapply-configs.sh
```

---

## 🎨 Theming

### Color Scheme: Catppuccin Mocha
All applications use the Catppuccin Mocha color palette for consistency:
- **Base**: #1e1e2e (Dark background)
- **Text**: #cdd6f4 (Light foreground)
- **Accent**: #89b4fa (Blue)
- **Warning**: #fab387 (Orange)

### Cursor Theme: Bibata Modern Classic
Selected automatically during install. Change with:
```bash
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic"
```

### Icon Theme: Papirus
Applied automatically. Folder colors and app icons are customized.

### GTK Theme: Default System Theme
Managed through `nwg-look` or directly:
```bash
gsettings set org.gnome.desktop.interface gtk-theme "adwaita"
```

---

## 🐛 Troubleshooting

### Installation Fails with Package Errors
Some packages may require additional setup (e.g., VirtualBox kernel modules). The install script gracefully skips failed packages and continues. Check logs:
```bash
cat ~/.config/hyprflux/install.log
```

### SDDM Theme Not Showing
Verify installation:
```bash
ls -la /usr/share/sddm/themes/simple-sddm-2/
```

If missing, reinstall:
```bash
sudo cp -r ~/hyprflux-simple/sddm-theme/* /usr/share/sddm/themes/simple-sddm-2/
sudo tee /etc/sddm.conf > /dev/null <<EOF
[General]
Session=hyprland
Current=simple-sddm-2
EOF
```

### Hyprland Doesn't Start
Check for missing dependencies:
```bash
bash ~/hyprflux-simple/scripts/validate.sh
```

If Wayland is required but not available, verify with:
```bash
echo $XDG_SESSION_TYPE  # Should output 'wayland'
```

### NeoVim Plugins Not Loading
Manually sync plugins:
```bash
nvim --headless "+Lazy! sync" "+qall"
```

### Tmux Plugins Not Loading
Install/update plugins:
```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Or reload config:
```bash
tmux source-file ~/.tmux.conf
```

### Fonts Not Rendering
Rebuild font cache:
```bash
fc-cache -fv
```

Verify fonts installed:
```bash
fc-list | grep -i "noto\|jetbrains"
```

### Web Apps Not Launching
Check .desktop files created:
```bash
ls -la ~/.local/share/applications/*webapp*
```

If missing, reapply:
```bash
bash ~/hyprflux-simple/scripts/reapply-configs.sh
```

---

## 🔄 Updates & Maintenance

### Update Everything (Reapply Configs)
```bash
cd ~/hyprflux-simple
git pull
bash scripts/reapply-configs.sh
```

This updates all configs without reinstalling packages.

### Update Packages Only
```bash
pacman -Syu
yay -Syu  # For AUR packages
```

### Update Individual Components

**NeoVim plugins**:
```bash
nvim --headless "+Lazy! sync" "+qall"
```

**NeoVim LSP servers**:
```bash
nvim --headless "+Mason" "+qall"
```

**Tmux plugins**:
```bash
~/.tmux/plugins/tpm/bin/update_plugins all
```

---

## 📦 Package Management

### View Installed Packages
```bash
pacman -Q | wc -l              # Total count
pacman -Q | grep hyprland      # Specific package
```

### Add Additional Packages
Edit `packages.txt` and rerun:
```bash
# Add package name, then:
sudo pacman -S <package_name>
```

### Remove Packages
```bash
sudo pacman -R <package_name>
```

### Install Optional Packages Not in List
```bash
yay -S <aur_package_name>
```

---

## 🔧 Advanced Usage

### Skip Package Installation
Install configs only (if packages already installed):
```bash
SKIP_PACKAGES=1 bash install.sh
```

### Skip Reboot Prompt
```bash
HYPRFLUX_SKIP_REBOOT=1 bash install.sh
```

### Custom Repository URL
```bash
HYPRFLUX_REPO=https://github.com/yourusername/your-fork.git bash install.sh
```

### Environment Variables
All configuration in `install.sh` can be overridden via env vars:
```bash
REPO_URL_WALLPAPER=<custom_url> bash install.sh
```

---

## 🔐 Uninstall / Restore Original Config

### Restore from Automatic Backup
During installation, a backup was created at `~/hyprflux-backup-TIMESTAMP/`:

```bash
# Find backup directory
ls -la ~/ | grep hyprflux-backup

# Restore
cp -r ~/hyprflux-backup-<TIMESTAMP>/* ~/
```

### Clean Remove
```bash
# Remove HyprFlux configs
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi

# Remove dotfiles
rm ~/.zshrc ~/.tmux.conf

# Remove SDDM theme
sudo rm -rf /usr/share/sddm/themes/simple-sddm-2

# Keep or remove packages as desired
pacman -R <package_name>
```

---

## 📊 Validation & Diagnostics

### Run Full Validation Check
```bash
bash ~/hyprflux-simple/scripts/validate.sh
```

This checks:
- OS compatibility
- All packages installed
- Configs deployed
- SDDM theme present
- Fonts available
- Web apps configured
- All essential tools available

**Output**:
```
[✓] Hyprland installed
[✓] Rofi installed
[✗] Docker not installed
... etc
```

---

## 💾 User Changes Backup

Before making major changes, backup your customizations:

```bash
bash ~/hyprflux-simple/scripts/backup-user-changes.sh
```

Creates timestamped backup at `~/hyprflux-changes-backup-YYYYMMDD_HHMMSS/`

**Restore from backup**:
```bash
cp -r ~/hyprflux-changes-backup-*/* ~/
```

---

## 🌳 What's NOT Included (by design)

We keep this setup simple and stable. Here's what's intentionally excluded:

❌ **Plymouth** - Boot animation (adds complexity, can break on updates)  
❌ **GRUB theming** - Bootloader customization (rarely visible, adds maintenance burden)  
❌ **Kernel parameters** - Quiet splash (cosmetic only)  
❌ **17+ Installation Modules** - Sequential dependency complexity  
❌ **Upstream Arch-Hyprland Dependency** - Full independence  

**Add these back if desired** - all are modular and don't affect core setup.

---

## 🤝 Contributing

Found a bug? Want to improve configs? Contributions welcome!

1. Fork repository
2. Create feature branch: `git checkout -b feature/my-improvement`
3. Commit: `git commit -am "Add improvement"`
4. Push: `git push origin feature/my-improvement`
5. Submit pull request

---

## 📄 License

This project is licensed under the [LICENSE](LICENSE) file. All configurations are provided as-is for personal use. Respect upstream project licenses (Hyprland, NeoVim, Tmux, etc.).

---

## 🙏 Acknowledgments

Built on the foundation of:
- **Hyprland Community** - Modern Wayland compositor
- **Catppuccin Project** - Beautiful color palette
- **Open Source Community** - All bundled tools and plugins
- **Original HyprFlux** - For inspiration on modular configuration

---

## 📞 Support

### Issues & Questions
1. Check [Troubleshooting](#-troubleshooting) section above
2. Run `bash ~/hyprflux-simple/scripts/validate.sh` to diagnose
3. Check logs: `cat ~/.config/hyprflux/install.log`
4. Open GitHub issue with validation output

### Manual Check Specific Tool
```bash
# Verify specific package
pacman -Q <package_name>

# Check binary exists
which <binary_name>

# Version info
<binary_name> --version
```

---

## ⭐ Quick Reference

| Task | Command |
|------|---------|
| **Run installer** | `bash install.sh` |
| **Validate install** | `bash scripts/validate.sh` |
| **Backup changes** | `bash scripts/backup-user-changes.sh` |
| **Update configs** | `bash scripts/reapply-configs.sh` |
| **View install log** | `cat ~/.config/hyprflux/install.log` |
| **Update Hyprland** | `sudo pacman -Syu` |
| **Update all configs** | `cd ~/hyprflux-simple && git pull` |
| **Reload SDDM config** | `sudo tee /etc/sddm.conf < /etc/sddm.conf` |
| **Restart Waybar** | `pkill waybar; waybar &` |
| **Restart Hyprland** | Press `SUPER+ALT+R` |

---

**Happy hacking! 🎉**

---

*Last updated: March 14, 2026*
*HyprFlux-Simple v1.0 - Stable Release*
