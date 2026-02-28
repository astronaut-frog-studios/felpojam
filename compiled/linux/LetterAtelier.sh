#!/bin/sh
printf '\033c\033]0;%s\a' Atelie de Cartas
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LetterAtelier.x86_64" "$@"
