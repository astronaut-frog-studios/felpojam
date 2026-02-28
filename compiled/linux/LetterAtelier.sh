#!/bin/sh
printf '\033c\033]0;%s\a' Letter Atelier
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LetterAtelier.x86_64" "$@"
