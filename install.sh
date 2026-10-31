#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

mkdir -p "$CONFIG_DIR"

# Array of directories to link inside ~/.config
CONFIG_TARGETS=("sway")

for target in "${CONFIG_TARGETS[@]}"; do
    src="$DOTFILES_DIR/config/$target"
    dest="$CONFIG_DIR/$target"

    if [ -d "$src" ]; then
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            echo "Backing up existing $dest to ${dest}.bak"
            mv "$dest" "${dest}.bak"
        elif [ -L "$dest" ]; then
            rm "$dest"
        fi

        echo "Linking $src -> $dest"
        ln -s "$src" "$dest"
    fi
done

echo "Dotfiles linked successfully."
