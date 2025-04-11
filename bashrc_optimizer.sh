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
export NEWT_COLORS=$NEWT_COLORS_5
# }}}

# Whiptail {{{
CHOICES=$(whiptail --title "Bashrc Setup Tool" --checklist \
"Use SPACE to select options and ENTER to confirm:" "$height" "$width" "$listheight" \
"Greet_user_at_login" "${spacer}" OFF \
"Logs_shell_login_events" "${spacer}" OFF \
"Set_default_start_folder" "${spacer}" OFF \
"Common_command_shortcuts" "${spacer}" OFF \
"Personalized_shell_prompt" "${spacer}" OFF \
"Logs_every_cd_action" "${spacer}" OFF \
"Show_random_shell_tips" "${spacer}" OFF \
"Show_git_branch_in_prompt" "${spacer}" OFF \
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
        "\"Greet_user_at_login\"") setup_welcome ;;
        "\"Logs_shell_login_events\"") setup_login_logs ;;
        "\"Set_default_start_folder\"") setup_start_directory ;;
        "\"Common_command_shortcuts\"") setup_aliases ;;
        "\"Personalized_shell_prompt\"") setup_prompt ;;
        "\"Logs_every_cd_action\"") setup_cd_logger ;;
        "\"Show_random_shell_tips\"") setup_bunner ;; 
        "\"Show_git_branch_in_prompt\"") setup_git_branch_prompt ;;
    esac
done # }}}

# }}}
