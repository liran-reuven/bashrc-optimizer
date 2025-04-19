#!/bin/bash

# Setup  Bashrc optimizer tool {{{

# Variables {{{
env_file="./config/env.sh"
timestamp=$(date +%Y-%m-%d_%H-%M-%S) # }}}

# Install dependencies {{{
    for pkg in whiptail; do
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

spacer=$(for i in $(seq 1 $((width - 37))); do echo -n " "; done) # }}}

# Customizing the whiptail {{{
export NEWT_COLORS=$NEWT_COLORS_2
# }}}

# Whiptail {{{
CHOICES=$(whiptail --title "Bashrc Setup Tool" --checklist \
"Use SPACE to select options and ENTER to confirm:" "$height" "$width" "$listheight" \
"WELCOME_MSG" "Add welcome message" OFF \
"SYS_SUMMARY" "System summary at login" OFF \
"SYS_UPTIME" "System uptime at login" OFF \
"TIPS_PACK" "Showrandom tips" OFF \
"ALIAS_PACK" "Useful aliases" OFF \
"LOGIN_LOGGER" "Log each login event" OFF \
"CD_LOGGER" "Log every directory change" OFF \
"GIT_BRANCH_PS1" "Show git branch in prompt" OFF \
"CUSTOM_PS1" "Set a custom PS1 prompt" OFF \
"DIR_POSITION" "Set start dir at login" OFF \
"GIT_PUSH" "Set shourcut git command" OFF \
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
        "\"WELCOME_MSG\"") setup_welcome ;;
        "\"SYS_UPTIME\"") setup_uptime ;;
        "\"SYS_SUMMARY\"") setup_system_info ;;
        "\"TIPS_PACK\"") setup_bunner ;; 
        "\"ALIAS_PACK\"") setup_aliases ;;
        "\"LOGIN_LOGGER\"") setup_login_logs ;;
        "\"CD_LOGGER\"") setup_cd_logger ;;
        "\"GIT_BRANCH_PS1\"") setup_git_branch_prompt ;;
        "\"CUSTOM_PS1\"") setup_prompt ;;
        "\"DIR_POSITION\"") setup_start_directory ;;
        "\"GIT_PUSH\"") setup_git_push ;;
    esac
done # }}}

# }}}
