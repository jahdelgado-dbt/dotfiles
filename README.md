# dotfiles

Source-controlled `$HOME` configs. Real files live in this repo; `$HOME` holds
symlinks pointing here.

## What's tracked

| Path in repo                              | Symlinked at                                  |
| ----------------------------------------- | --------------------------------------------- |
| `.zshrc`                                  | `~/.zshrc`                                    |
| `.zprofile`                               | `~/.zprofile`                                 |
| `.gitconfig`                              | `~/.gitconfig`                                |
| `.config/git/ignore`                      | `~/.config/git/ignore`                        |
| `.config/ghostty/config`                  | `~/.config/ghostty/config`                    |
| `.config/ghostty/shaders/pipboy-crt.glsl` | `~/.config/ghostty/shaders/pipboy-crt.glsl`   |
| `.claude/settings.json`                   | `~/.claude/settings.json`                     |

## Install on a new machine

```sh
git clone https://github.com/jahdelgado-dbt/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is idempotent. Any existing real files at the target paths get
moved to `~/.dotfiles-backup-<timestamp>/` before being replaced with symlinks.

## Adding a new dotfile

1. Move the file into this repo at the same relative path
   (`mv ~/.foo ~/dotfiles/.foo`).
2. Add the path to the `FILES=(...)` list in `install.sh`.
3. Add a `!path/to/file` un-ignore line to `.gitignore`.
4. Run `~/dotfiles/install.sh` to create the symlink.
5. Commit.

## Secrets policy

`.gitignore` is deny-by-default — anything not explicitly un-ignored is
invisible to git. Don't disable that. Things that must **never** land in
this repo:

- `~/.ssh/`, `~/.kube/`, `~/.tsh/`, `~/.aws/`, `~/.gnupg/`, `~/.netrc`
- `~/.claude.json` (OAuth tokens), `~/.claude/sessions/`, `~/.claude/projects/`,
  `~/.claude/history.jsonl`, etc.
- `~/.dbt/profiles.yml`, `~/.pg_service.conf` (database credentials)
- `~/.zsh_history`

If you accidentally commit a secret: rotate it immediately, then rewrite
history with `git filter-repo` and force-push. Assume anything pushed to
GitHub is permanently public.
