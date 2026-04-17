# configuration

My personal dotfiles for nvim, LazyVim, wezterm, tmux and shell scripts.

## Structure

```
dotfiles/
  nvim/
  LazyVim/
  wezterm/
  tmux/
  bin/
  .zshrc
```

## Install on a new machine

```bash
bash <(curl -s https://raw.githubusercontent.com/Zeroluffs/configuration/main/bin/dotfiles-install.sh)
```

This will:
- Clone the repo into `~/dotfiles`
- Symlink all configs to their correct locations
- Symlink all scripts into `~/bin`

## Updating configs

Since configs are symlinked, just edit them as normal then:

```bash
cd ~/dotfiles
git add/commit/push
```

Or run the `dots` alias (see below) to copy + commit + push everything in one go.

## Syncing to another machine

```bash
cd ~/dotfiles && git pull
```

## Alias

Add this to your `.zshrc` to use the `dots` command:

```bash
alias dots=~/bin/dotfiles.sh
```

---

## Add a new config to sync

The two scripts that make this work are:

- `bin/dotfiles.sh` — runs on the machine that owns the source of truth; copies configs from `~/.config` (or wherever) into the repo, commits, and pushes.
- `bin/bin/dotfiles-install.sh` — runs on a fresh machine; removes the target, then symlinks the repo version back into `~/.config`.

To add a new config folder (example: `~/.config/ghostty`), follow these steps in order.

### 1. Pick a repo subfolder name

Convention: mirror the source folder name. `~/.config/ghostty` → `dotfiles/ghostty`.

### 2. Edit `bin/dotfiles.sh` (the push script)

Two edits, both inside this file:

**(a)** Add a `cp -r` line alongside the existing ones:

```bash
cp -r ~/.config/nvim     $DOTFILES
cp -r ~/.config/LazyVim  $DOTFILES
cp -r ~/.config/wezterm  $DOTFILES
cp -r ~/.config/tmux     $DOTFILES
cp -r ~/.config/ghostty  $DOTFILES      # <- new
cp -r ~/bin              $DOTFILES/bin
```

**(b)** Add the folder name to the `for dir in …` loop so it gets its own commit:

```bash
for dir in nvim LazyVim wezterm tmux ghostty; do
```

### 3. Edit `bin/bin/dotfiles-install.sh` (the pull + symlink script)

Two edits, both inside this file:

**(a)** Add an `rm -rf` line so a stale folder doesn't block the symlink:

```bash
rm -rf ~/.config/ghostty
```

**(b)** Add the matching `ln -sf` line:

```bash
ln -sf $DOTFILES/ghostty ~/.config/ghostty
```

### 4. Run it once from the source machine

```bash
dots
```

This copies `~/.config/ghostty` into `~/dotfiles/ghostty`, commits it as `ghostty: update config`, and pushes.

### 5. On other machines, re-run the installer (or symlink manually)

```bash
cd ~/dotfiles && git pull
rm -rf ~/.config/ghostty
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
```

### Gotchas

- **`cp` overwrites, doesn't merge.** If you edit a file in `~/dotfiles/ghostty` directly and forget to mirror it in `~/.config/ghostty`, the next `dots` run will overwrite your repo change. Always edit the live path (`~/.config/ghostty/...`), not the repo copy.
- **The repo tracks `cp`s, not symlinks — on the source machine.** The installer creates symlinks, but the push script does plain copies. That's why step 4 works even if you already symlinked — `cp -r` follows the symlink and writes real files into the repo.
- **Lockfiles.** If the tool has a lockfile (e.g. `lazy-lock.json`), decide whether to commit it (reproducible across machines) or `.gitignore` it (fresh resolve per machine). Default is: commit it.
- **Secrets.** Don't add anything with API keys or tokens. Add a `.gitignore` entry at the repo root or inside the subfolder before the first `dots` run.
- **First install on a machine with existing config.** `dotfiles-install.sh` runs `rm -rf` on the target. If a machine has uncommitted work in that folder, commit or back it up first.

### Removing a synced config

Reverse the above:

1. Remove the `cp -r` and the `for dir in` entry in `bin/dotfiles.sh`.
2. Remove the `rm -rf` and `ln -sf` lines in `bin/bin/dotfiles-install.sh`.
3. `git rm -r <folder>` in the repo, commit, push.
4. On each machine, replace the symlink with a real copy if you want to keep it locally: `cp -rL ~/.config/<folder> /tmp/x && rm ~/.config/<folder> && mv /tmp/x ~/.config/<folder>`.
