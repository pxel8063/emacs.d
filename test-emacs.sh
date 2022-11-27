#!/usr/bin/env bash

export XDG_CONFIG_HOME=${GITHUB_WORKSPACE:-${XDG_CONFIG_HOME:-$HOME/.config}}

cd "$XDG_CONFIG_HOME/emacs" && {
    make compile
    make test
}
