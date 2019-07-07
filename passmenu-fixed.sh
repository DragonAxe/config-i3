#!/usr/bin/env bash

################################################################################
##                DragonAxe passmenu fixed to follow symlinks                 ##
################################################################################

# This is a modified passmenu script designed to
# enable the following of symlinks within the .password-store

shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
        typeit=1
        shift
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}

# Fix to follow symlinks in password store is to use find -L.
# While loop required to copy find -print0 output to bash array.
# password_files=( "$prefix"/**/*.gpg )
password_files=()
while IFS=  read -r -d $'\0'; do
    password_files+=("$REPLY")
done < <(find -L "$prefix" -iname "*.gpg" -print0)

password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")

[[ -n $password ]] || exit

if [[ $typeit -eq 0 ]]; then
        pass show -c "$password" 2>/dev/null
else
        pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } |
                xdotool type --clearmodifiers --file -
fi

