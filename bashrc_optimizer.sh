#!/bin/bash

# Setup  Bashrc optimizer tool {{{

# Variables {{{
env_file="./config/env.sh"
timestamp=$(date +%Y-%m-%d_%H-%M-%S) # }}}

# Install dependencies {{{
    for pkg in figlet gem lolcat; do
        if ! command -v $pkg &>/dev/null; then
            echo "$pkg not found. Installing..."
            apt update | apt install -y $pkg
        fi
    done # }}}

# Check if env file exist {{{
if [ -f "$env_file" ];
then
    source "$env_file"
else
    printf "[ERROR] Missing env file"
fi # }}}

# Check if function file exist {{{
if [ -f "$function_file" ];
then
    source "$function_file"
else
    printf "[ERROR] Missing function file"
fi # }}}

# Check if colors file exist {{{
if [ -f "$colors_file" ];
then
    source "$colors_file"
else
    printf "[ERROR] Missing colors file"
fi # }}}

# Check if .bashrc file exist {{{
if [ ! -f "$bashrc_file" ];
then
    touch $HOME/.bashrc
fi # }}}

# Check if backup directory exist and create cope of .bashrc file {{{
if [ -d "$backup_dir" ];
then
    cp "$bashrc_file" "$backup_dir/bashrc_backup_$timestamp"
else
    mkdir $backup_dir
    cp "$bashrc_file" "$backup_dir/bashrc_backup_$timestamp"
fi # }}}

 # }}}

# Menu System {{{ 

# Setup Dimensions for whiptail {{{
rows=$(tput lines)
cols=$(tput cols)

height=$((rows * 60 / 100))
width=$((cols * 70 / 100))
listheight=$((height - 10))

spacer=$(for i in $(seq 1 $((width - 36))); do echo -n " "; done) # }}}

# Customizing the whiptail {{{
export NEWT_COLORS='
root=,blue
window=,black
shadow=,blue
border=blue,black
title=blue,black
textbox=blue,black
radiolist=black,black
label=black,blue
checkbox=black,blue
compactbutton=black,blue
button=black,red
' # }}}

# Whiptail {{{
CHOICES=$(whiptail --title "Bashrc Setup Tool" --checklist \
"Use SPACE to select options and ENTER to confirm:" "$height" "$width" "$listheight" \
"1" "Add welcome message${spacer}" OFF \
"2" "Add aliases${spacer}" OFF \
"3" "Customize prompt${spacer}" OFF \
"4" "Enable cd logger${spacer}" OFF \
"5" "Add tips of the day${spacer}" OFF \
"6" "Setup git branch prompt${spacer}" OFF \
3>&1 1>&2 2>&3) # }}}

# Check if there is a selection from the user {{{
exitstatus=$?

if [ $exitstatus -eq 0 ]; then
    echo "You selected."
else
    echo "You canceled."
    exit 1
fi # }}}

# Loop for setup the selections {{{
for choice in $CHOICES; do
    case $choice in
        "\"1\"") setup_welcome ;;
        "\"2\"") setup_aliases ;;
        "\"3\"") setup_prompt ;;
        "\"4\"") setup_cd_logger ;;
        "\"5\"") setup_bunner ;; 
        "\"6\"") setup_git_branch_prompt ;;
    esac
done # }}}

# }}}
