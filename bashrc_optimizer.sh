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
listheight=$((height - 7))

spacer=$(for i in $(seq 1 $((width - 80))); do echo -n " "; done) # }}}

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
"welcome_message" "    Add welcome message include the date, time.${spacer}" OFF \
"login_log" "    Add logger for user logins.${spacer}" OFF \
"start_directory" "    Change where you start when you enter the user.${spacer}" OFF \
"aliases" "    Add basic aliases for commands like ls and rm.${spacer}" OFF \
"custom_prompt" "    Customiez your ps1 prompt.${spacer}" OFF \
"cd_logger" "    Add cd logger for changing dirctorys.${spacer}" OFF \
"tips" "    Add some tips you can custom the tips at...${spacer}" OFF \
"git_branch_prompt" "${spacer}" OFF \
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
        "\"welcome_message\"") setup_welcome ;;
        "\"login_log\"") setup_login_log ;;
        "\"start_directory\"") setup_start_directory ;;
        "\"aliases\"") setup_aliases ;;
        "\"custom_prompt\"") setup_prompt ;;
        "\"cd_logger\"") setup_cd_logger ;;
        "\"tips\"") setup_bunner ;; 
        "\"git_branch_prompt\"") setup_git_branch_prompt ;;
    esac
done # }}}

# }}}
