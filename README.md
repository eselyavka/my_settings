# my_settings

Personal shell, editor, Git, PostgreSQL, GTK, and Linux utility settings.

This repository is now organized by tool. The old top-level filenames are kept as compatibility symlinks, so existing references still work while the layout stays easier to navigate.

Use the bootstrap script for installation:

```bash
./install/bootstrap.sh --all
./install/bootstrap.sh --vim --git
./install/bootstrap.sh --examples
./install/bootstrap.sh --all --examples
./install/bootstrap.sh --all --dry-run
./install/validate.sh
```

`bootstrap.sh` is platform-aware:

1. On macOS, `--all` installs portable configs only.
2. On Linux, `--all` installs portable configs plus Linux-specific GTK config.
3. `--gtk` is treated as Linux-specific and is skipped automatically on non-Linux hosts.
4. `--examples` copies local override templates into `$HOME` without changing tracked base configs.

## What is here

| File | Purpose | Notes |
| --- | --- | --- |
| `shell/bash_profile` | Interactive shell defaults | Prompt, history, pager, `less` flags |
| `shell/env.sh` | Shell environment defaults | Shared environment variables |
| `shell/prompt.sh` | Shell prompt config | Prompt definition |
| `shell/history.sh` | Shell history config | History persistence and limits |
| `shell/bash_profile.local.example` | Machine-local shell overrides | Example for host-specific aliases, PATH, and exports |
| `vim/vimrc` | Vim configuration | Plugin-manager-free base config with built-in netrw |
| `vim/vimrc.local.example` | Machine-local Vim overrides | Example for host-specific editor tweaks and optional YCM |
| `vim/legacy/ycm_extra_conf.py` | Optional YouCompleteMe fallback compile flags | Legacy file kept for manual YCM setups only |
| `git/gitconfig` | Git identity and aliases | Small alias set, editor, diff/status defaults |
| `git/gitconfig.local.example` | Machine-local Git overrides | Example for host-specific identity or SSH settings |
| `psql/psqlrc` | PostgreSQL `psql` helpers | Formatting and a large library of admin queries |
| `psql/psqlrc.local.example` | Machine-local psql overrides | Example for host-specific prompt or pager settings |
| `gui/gtk.css` | GTK terminal styling | Visual tweaks for terminal tabs/background |
| `scripts/legacy/ubuntu-unity-disable-scopes.sh` | Ubuntu Unity cleanup script | Obsolete Ubuntu 14.04-era script kept for reference |
| `docs/useful_cmd.md` | Personal command cheat sheet | System and Git command snippets |
| `install/bootstrap.sh` | Installer | Symlinks selected configs into `$HOME` |
| `install/validate.sh` | Validator | Checks repo structure, compatibility symlinks, and override hooks |

## Quick use

The preferred installation path is `./install/bootstrap.sh`. Manual linking still works if you want full control.

For a new machine, a practical first run is:

```bash
./install/bootstrap.sh --all --examples
```

To validate the repository structure and install assumptions:

```bash
./install/validate.sh
```

When `shellcheck` is available, the validator also lints the tracked shell scripts.

GitHub Actions installs `shellcheck` and runs this validator automatically on pushes and pull requests on both Ubuntu and macOS.

Typical mappings:

| Repo file | Target |
| --- | --- |
| `shell/bash_profile` | `~/.bash_profile` |
| `vim/vimrc` | `~/.vimrc` |
| `git/gitconfig` | `~/.gitconfig` |
| `psql/psqlrc` | `~/.psqlrc` |
| `gui/gtk.css` | `~/.config/gtk-3.0/gtk.css` |

Example with symlinks:

```bash
ln -s "$PWD/shell/bash_profile" ~/.bash_profile
ln -s "$PWD/vim/vimrc" ~/.vimrc
ln -s "$PWD/git/gitconfig" ~/.gitconfig
ln -s "$PWD/psql/psqlrc" ~/.psqlrc
```

## Notable contents

### Shell

`shell/bash_profile` is now a small entrypoint that sources tracked shell fragments for environment variables, prompt settings, and history behavior. It still sources `~/.bash_profile.local` when present, so host-specific aliases, `PATH` changes, or secrets do not need to live in the tracked config.

Use [shell/bash_profile.local.example](/Users/eseliavka/projects/my_settings/shell/bash_profile.local.example#L1) as the starting point for machine-local shell overrides.

### Vim

`vim/vimrc` is now a plugin-manager-free base config. It keeps editor defaults in the tracked file and uses built-in netrw for file browsing instead of depending on NERDTree.

This is a better default for this repo because:

1. a fresh machine can use the config immediately without bootstrapping Vundle first;
2. the plugin surface is smaller and easier to maintain across macOS and Ubuntu;
3. heavyweight completion tooling is no longer a hidden dependency of the base editor setup.

Host-specific Vim settings can live in `~/.vimrc.local`. Use [vim/vimrc.local.example](/Users/eseliavka/projects/my_settings/vim/vimrc.local.example#L1) as a template.

`vim/legacy/ycm_extra_conf.py` is still kept in the repo, but YouCompleteMe is now treated as optional legacy tooling. If you still want it on a specific machine, enable it from `~/.vimrc.local` and symlink `vim/legacy/ycm_extra_conf.py` to `~/.vim/legacy/ycm_extra_conf.py` manually.

### Git

`git/gitconfig` now includes `~/.gitconfig.local`, which is the right place for machine-specific identity, SSH command overrides, or work-only settings. Use [git/gitconfig.local.example](/Users/eseliavka/projects/my_settings/git/gitconfig.local.example#L1) as a template.

### PostgreSQL

`psql/psqlrc` is the most content-rich file in the repository. It acts as a compact PostgreSQL operations toolbox with query shortcuts for locks, waits, bloat, vacuum pressure, duplicate indexes, and more. This is worth preserving carefully and documenting well because it contains the most domain-specific value in the repo.

It now loads query groups from `psql/queries/` and conditionally includes `~/.psqlrc.local` for host-specific overrides. Use [psql/psqlrc.local.example](/Users/eseliavka/projects/my_settings/psql/psqlrc.local.example#L1) as a template.

### Utility files

`docs/useful_cmd.md` is now organized by topic so it is easier to scan and extend.

`scripts/legacy/ubuntu-unity-disable-scopes.sh` targets Ubuntu Unity on Ubuntu 14.04-era systems. It is kept as a legacy reference and should not be run on a modern machine without reviewing every command first.

## Current risks and cleanup candidates

These are worth addressing before expanding the repo:

1. `scripts/legacy/ubuntu-unity-disable-scopes.sh` uses `sudo rm` and targets a desktop stack that is no longer current.
2. The Git/Vim/psql local override files are documented, but not bootstrapped into `$HOME` automatically.
3. `vim/legacy/ycm_extra_conf.py` depends on YouCompleteMe and `ycm_core`, so it is only useful on machines where YCM is installed intentionally.
4. The shell config is split into a few basics, but aliases and reusable shell functions are not yet broken into tracked files.

## Current layout

```text
.
├── README.md
├── shell/
│   ├── bash_profile
│   ├── env.sh
│   ├── history.sh
│   ├── prompt.sh
│   └── bash_profile.local.example
├── git/
│   ├── gitconfig
│   └── gitconfig.local.example
├── vim/
│   ├── vimrc
│   ├── vimrc.local.example
│   └── legacy/
│       └── ycm_extra_conf.py
├── psql/
│   ├── psqlrc
│   ├── psqlrc.local.example
│   └── queries/
│       ├── activity.sql
│       ├── indexes.sql
│       └── storage.sql
├── gui/
│   └── gtk.css
├── scripts/
│   └── legacy/
│       └── ubuntu-unity-disable-scopes.sh
├── docs/
│   └── useful_cmd.md
└── install/
    ├── bootstrap.sh
    └── validate.sh
```

The top-level names such as `bash_profile`, `vimrc`, and `gitconfig` remain present as symlinks to these files for compatibility.

## Why this helps

1. Groups files by tool instead of filename convention.
2. Makes platform-specific or legacy content easier to isolate.
3. Gives you a clean place for install scripts and generated docs.
4. Makes the README much shorter over time because each area can own its own local notes.

## Local Overrides

Tracked base configs stay portable. Host-specific changes go into ignored local files in `$HOME`.

| Tool | Local file |
| --- | --- |
| shell | `~/.bash_profile.local` |
| git | `~/.gitconfig.local` |
| vim | `~/.vimrc.local` |
| psql | `~/.psqlrc.local` |

Use `./install/bootstrap.sh --examples` to create these files from the tracked `.example` templates when they do not already exist.

## Platform notes

| Area | macOS | Ubuntu/Linux |
| --- | --- | --- |
| shell | Yes | Yes |
| git | Yes | Yes |
| vim | Yes | Yes |
| psql | Yes | Yes |
| gtk | No | Yes |
| legacy Unity script | No | Legacy only |

## Suggested roadmap

1. Split `psql/psqlrc` into a base config plus sourced query files if you expect it to keep growing.
2. Mark legacy or OS-specific scripts clearly, for example `scripts/legacy/ubuntu-unity-disable-scopes.sh`.
3. Remove `vim/legacy/ycm_extra_conf.py` entirely if YouCompleteMe is no longer used anywhere.

## If you want this repo to become a real dotfiles repo

A stronger second-stage refactor would add:

1. an installer with flags like `--shell`, `--vim`, `--git`, `--psql`;
2. a `Brewfile` or package manifest for dependencies;
3. a `docs/` section with screenshots or examples for the higher-value configs;
4. a validation script that checks expected target paths and missing dependencies.

That would turn this from "personal backup of settings" into "repeatable workstation bootstrap".
