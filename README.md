# NixOS config — Kirill

Single-host NixOS configuration for `pc` (MSI PRO Z790-A WIFI / i7-13700KF / RTX 4080 / 64 GB DDR5).

## Files

```
flake.nix                            # inputs + outputs
hosts/pc/configuration.nix           # everything system-level
hosts/pc/disko.nix                   # disk partitioning
hosts/pc/hardware-configuration.nix  # generated on the target machine at install
home.nix                             # everything user-level (home-manager)
README.md
.gitignore
```

## Install from the NixOS minimal live USB

### 1. Boot + Ethernet

Boot from the USB, log in as `nixos`, make sure internet works:

```bash
ping -c 1 nixos.org
```

### 2. Find the by-id path of the empty 1 TB SSD

```bash
ls -l /dev/disk/by-id/ | grep -i samsung
lsblk
```

Copy the full `/dev/disk/by-id/nvme-...` path that corresponds to the 1 TB drive.

### 3. Clone this repo

```bash
nix-shell -p git
git clone https://github.com/<YOUR_GITHUB_USERNAME>/nixos-config /tmp/nixos-config
cd /tmp/nixos-config
```

### 4. Edit `hosts/pc/disko.nix`

Replace `/dev/disk/by-id/REPLACE_ME` with the real path from step 2.

```bash
nano hosts/pc/disko.nix
```

### 5. Partition + format + mount with disko

```bash
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  --flake /tmp/nixos-config#pc
```

Read disko's output before confirming. It MUST only touch the 1 TB drive.

### 6. Generate hardware-configuration.nix

```bash
sudo nixos-generate-config --no-filesystems --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/nixos-config/hosts/pc/
```

### 7. Install

```bash
sudo nixos-install --flake /tmp/nixos-config#pc
```

You will be asked to set the **root** password at the end of the install. Set something memorable.

### 8. Reboot, choose boot drive via F11

```bash
sudo reboot
```

Pull out the USB stick. To boot NixOS, just power on. To boot Windows, hit F11 at POST and pick the 2 TB drive.

### 9. First login

tuigreet shows on tty1 with username `kirnik233899`. You haven't set the password yet:

- press Ctrl+Alt+F2 to switch to a TTY
- log in as `root` with the password you set in step 7
- run `passwd kirnik233899`
- switch back to tty1 (Ctrl+Alt+F1), log in, niri starts

### 10. Move the config to home

```bash
sudo mv /tmp/nixos-config ~/nixos-config
sudo chown -R kirnik233899:users ~/nixos-config
cd ~/nixos-config
```

Future rebuilds:

```bash
nrs   # alias for: doas nixos-rebuild switch --flake ~/nixos-config#pc
```

## Notes

- Windows on the 2 TB drive is untouched. Boot it via F11.
- No LUKS, no impermanence, no hibernation.
- Mullvad: after install, `mullvad account login <ACCOUNT_NUMBER>` for the "Live Rat" account.
- Snapper takes hourly/daily/weekly/monthly snapshots of `/home`. List: `snapper -c home list`. Rollback: `snapper -c home rollback <id>`.
- Update inputs: `nfu` (alias). Apply: `nrs`.

## Switching to NixOS 26.05 later

Replace `nixos-25.11` / `release-25.11` with `nixos-26.05` / `release-26.05` in `flake.nix`, then `nfu && nrs`.
