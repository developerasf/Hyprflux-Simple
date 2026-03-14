# HyprFlux-Simple: Quick Installation Guide

## 🚀 TL;DR - One Command Install

```bash
curl -O https://raw.githubusercontent.com/yourusername/hyprflux-simple/main/install.sh && bash install.sh
```

**What happens**:
- ✅ Downloads 50+ packages (Hyprland, Rofi, Waybar, NeoVim, Tmux, etc.)
- ✅ Deploys all your dotfiles, configs, themes
- ✅ Sets up SDDM login screen
- ✅ Configures NeoVim, Tmux, Zsh
- ✅ Creates Chromium web app shortcuts (WhatsApp, Telegram, Teams, Office365)
- ✅ Backs up your existing configs automatically
- ❌ Takes 10-20 minutes (depending on internet speed)
- ❌ Requires sudo access
- ❌ Requires Arch Linux (or Manjaro, EndeavourOS, etc.)

---

## 📋 What You Need

- **Arch Linux** (or derivative)
- **sudo password** (will ask for this during install)
- **Internet connection**
- **~2GB disk space**
- **30+ minutes** (first install)

---

## ✨ What Gets Installed

### Desktop Environment
- Hyprland (Wayland compositor)
- Rofi (app launcher)
- Waybar (system bar)
- Swww (wallpaper daemon)

### Terminals & Shells
- Kitty (terminal)
- Foot, Ghostty (alternatives)
- Zsh + Oh My Zsh
- Starship (prompt)

### Development Tools
- NeoVim (pre-configured)
- Tmux (terminal multiplexer)
- Git, Lazygit, Git-delta
- VS Codium, Docker, Docker-compose

### System Tools
- Hyprlock (screen locker)
- Hypridle (idle daemon)
- Network Manager applet
- Blueman (Bluetooth manager)
- PulseAudio controls (pavucontrol)

### Multimedia
- Firefox, Chromium, Brave
- Mpv (video player)
- Gimp (image editor)
- Zathura (PDF viewer)

### Utilities
- Thunar (file manager)
- Clip hist (clipboard manager)
- Grim + Slurp (screenshots)
- Bat, Eza, Ripgrep, FZF
- Btop, Fastfetch (system info)

### Fonts & Theming
- Noto Sans, JetBrains Mono
- Bibata cursor
- Papirus icons
- Qt5/Qt6 themes

### And Much More...
See [packages.txt](packages.txt) for the full list (140+ packages!)

---

## 🎯 Step-by-Step

### Option A: From GitHub (Fresh Install)
1. Boot fresh Arch Linux
2. Open terminal
3. Paste: `curl -O https://raw.githubusercontent.com/yourusername/hyprflux-simple/main/install.sh && bash install.sh`
4. Enter sudo password when prompted
5. Wait 15-30 minutes
6. Reboot when asked
7. Log in with SDDM theme
8. Enjoy Hyprland!

### Option B: From Local Directory
1. Clone repo: `git clone https://github.com/yourusername/hyprflux-simple.git`
2. Enter directory: `cd hyprflux-simple`
3. Run installer: `bash install.sh`
4. Follow same steps as Option A

### Option C: Dry Run (Preview without installing)
```bash
bash install.sh --dry-run
```
See what would be installed without making changes.

---

## ⚙️ During Installation

The script will:

1. **Check OS** - Verify Arch Linux
2. **Update System** - `pacman -Sy`
3. **Install Packages** - 50+ apps (takes 10-20 min depending on internet)
4. **Backup Configs** - Creates `~/hyprflux-backup-TIMESTAMP/` before touching anything
5. **Deploy Files** - Copies all .config, dotfiles, themes
6. **Setup SDDM** - Installs login screen theme
7. **Setup NeoVim** - Installs plugins
8. **Setup Tmux** - Installs plugin manager
9. **Setup Fonts** - Builds font cache
10. **Setup Web Apps** - Creates desktop shortcuts
11. **Validate** - Checks everything worked
12. **Ask to Reboot** - You must reboot for changes to take effect!

---

## ⏭️ After Installation

### First Boot
1. Reboot when installer asks
2. Login with SDDM theme (password required)
3. Hyprland desktop loads
4. Click anywhere, then hit SUPER (Windows key) to see keybinds

### Customize

**Change Hyprland settings**:
```bash
~/.config/hypr/UserConfigs/
```

**Change Waybar**:
```bash
~/.config/waybar/config.jsonc
~/.config/waybar/style.css
```

**Change Rofi theme**:
```bash
~/.config/rofi/config.rasi
```

**Change Terminal colors**:
```bash
~/.config/kitty/kitty.conf
```

**Delete/modify web apps**:
```bash
~/.local/share/applications/*webapp*
```

---

## 🔍 Check Installation

Verify everything installed correctly:

```bash
bash ~/hyprflux-simple/scripts/validate.sh
```

Output will show ✓ for working, ✗ for missing.

---

## ⚠️ Common Issues & Fixes

### "Command not found: pacman"
→ You're not on Arch Linux. This script requires Arch (or Manjaro, EndeavourOS, etc.)

### "sudo: command not found"
→ Install sudo: `su -c 'pacman -S sudo'` (as root)

### Installation stuck on package install
→ Network issue. Script will retry 3x then continue.
→ Check: `cat ~/.config/hyprflux/install.log` for details

### Packages installed but configs not applied
→ Run: `bash ~/hyprflux-simple/scripts/reapply-configs.sh`

### SDDM theme not showing (black screen on boot)
→ Reboot again, usually works on second boot
→ Or manually: `sudo tee /etc/sddm.conf` and update

### Can't login (SDDM password not working)
→ Use TTY login: CTRL+ALT+F2
→ Run: `bash ~/hyprflux-simple/install.sh` again

### Hyprland not starting (black screen)
→ Check logs: `journalctl -xe` or `cat ~/.config/hyprflux/install.log`
→ Run validation: `bash ~/hyprflux-simple/scripts/validate.sh`

### NeoVim plugins not loading
→ Manual sync: `nvim --headless "+Lazy! sync" "+qall"`

### Tmux plugins not loading
→ Reload config: `tmux source-file ~/.tmux.conf`

---

## 🔄 Update & Maintenance

### Update All Configs (No reinstall)
```bash
cd ~/hyprflux-simple
git pull
bash scripts/reapply-configs.sh
```

### Update Packages
```bash
pacman -Syu              # System update
pacman -Syu hyprland     # Specific package
yay -Syu                 # AUR updates
```

### Backup Your Changes Before Major Updates
```bash
bash ~/hyprflux-simple/scripts/backup-user-changes.sh
```

---

## 🚮 Uninstall / Restore Backup

If something goes wrong, restore automatically created backup:

```bash
# Find backup
ls -la ~/ | grep hyprflux-backup

# Restore
cp -r ~/hyprflux-backup-TIMESTAMP/* ~/
```

This restores your original configs before installation.

---

## 📖 Full Documentation

For complete docs, advanced usage, keyboard shortcuts, and troubleshooting:

👉 **See [README.md](README.md)**

---

## 💡 Tips & Tricks

**Enter Hyprland keybind menu**:
- Press `SUPER` (Windows key)
- Shows all keybinds

**Launch app**:
- `SUPER + SPACE` → Rofi launcher

**Take screenshot**:
- `SUPER + SHIFT + S` → Screenshot editor

**Open terminal**:
- `SUPER + RETURN` → Kitty

**Switch workspaces**:
- `SUPER + 1-9` → Jump to workspace
- `SUPER + SHIFT + 1-9` → Move window to workspace

**Close window**:
- `SUPER + Q` → Close

**Reload Hyprland**:
- `SUPER + ALT + R` → Restart

**Check NeoVim setup**:
- `nvim` → Open
- `:Lazy status` → Check plugins
- `:Mason` → Check LSP servers

---

## 🆘 Need Help?

1. **Check logs**: `cat ~/.config/hyprflux/install.log`
2. **Run validation**: `bash ~/hyprflux-simple/scripts/validate.sh`
3. **Read docs**: [README.md](README.md)
4. **Search GitHub issues**: github.com/yourusername/hyprflux-simple/issues
5. **Ask on Reddit**: r/hyprland, r/archlinux

---

## ✅ What's Next?

After installation:
- [ ] Reboot and login
- [ ] Test Hyprland (press SUPER)
- [ ] Customize Hyprland settings
- [ ] Add your own wallpapers
- [ ] Install additional packages with `yay`
- [ ] Check out the documentation
- [ ] Enjoy your new desktop!

---

**Happy hacking!** 🎉

Need help? Check [README.md](README.md) for complete documentation.
