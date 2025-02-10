#!/bin/bash

## CONSTs ##
DOTFILES_DIR=$(dirname "$(realpath "$0")")
TMUX_CONF_PATH="$HOME/.tmux.conf"
ZSHRC_PATH="$HOME/.zshrc"
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
FZF_PATH="$ZSH_CUSTOM_DIR/fzf.zsh"
FZF_GIT_PATH="$ZSH_CUSTOM_DIR/fzf-git.zsh"
ALIASES_PATH="$ZSH_CUSTOM_DIR/aliases.zsh"
PATH_PATH="$ZSH_CUSTOM_DIR/path.zsh"


## UTILs ##

ask() {
    local prompt="$1"
    while true; do
        read -p "$prompt (y/n): " choice
        case "$choice" in
            y|Y)
                return 0
                ;;
            n|N)
                return 1
                ;;
            *)
                echo "Invalid input. Plz enter 'y' or 'n'."
                ;;
        esac
    done
}

overwrite_file() {
    local file="$1"
    if [ -e "$file" ]; then
        echo "[-] $file already exists"
        if ! ask "[?] Do you want to overwite exists file?"; then
            return 1
        fi
    fi
}


## TMUX ##

tmux() {
    echo "[+] Tmux configuration started" 
    if ! overwrite_file $TMUX_CONF_PATH; then
        echo "[-] Tmux configuration aborted"
        return
    fi

    echo "source-file $DOTFILES_DIR/tmux.conf" > $TMUX_CONF_PATH

    echo "[+] Tmux configuration done" 
}

## SHELL ##

shell() {
    echo "[+] Shell configuration started"

    if ! overwrite_file $ZSHRC_PATH; then
        echo "[-] Skipping $ZSHRC_PATH"
    else
        echo "[+] Remove $ZSHRC_PATH and create symlink"
        rm $ZSHRC_PATH
        ln -s $DOTFILES_DIR/zshrc $ZSHRC_PATH
    fi

    if [ ! -e "$ZSH_CUSTOM_DIR" ]; then
        echo "[-] Missing oh-my-zsh custom directory"
        echo "[-] Shell configuration aborted"
        return
    fi

    if ! overwrite_file $FZF_PATH; then
        echo "[-] Skipping $FZF_PATH"
    else
        echo "[+] Remove $FZF_PATH and create symlink"
        rm $FZF_PATH
        ln -s $DOTFILES_DIR/fzf.zsh $FZF_PATH
    fi

    if ! overwrite_file $FZF_GIT_PATH; then
        echo "[-] Skipping $FZF_GIT_PATH"
    else
        echo "[+] Remove $FZF_GIT_PATH and create symlink"
        rm $FZF_GIT_PATH
        ln -s $DOTFILES_DIR/fzf-git.sh $FZF_GIT_PATH
    fi

    if ! overwrite_file $ALIASES_PATH; then
        echo "[-] Skipping $ALIASES_PATH"
    else
        echo "[+] Remove $ALIASES_PATH and create symlink"
        rm $ALIASES_PATH
        ln -s $DOTFILES_DIR/aliases.zsh $ALIASES_PATH
    fi

    if ! overwrite_file $PATH_PATH; then
        echo "[-] Skipping $PATH_PATH"
    else
        echo "[+] Remove $PATH_PATH and create new one"
        rm $PATH_PATH
        echo "PATH=:\$PATH" > $PATH_PATH
    fi
    
    echo "[+] Shell configuration done"
}


tmux
shell