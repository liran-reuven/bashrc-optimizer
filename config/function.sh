# Functions

# Data Print {{{

setup_welcome() { # {{{
cat << EOL >> "$bashrc_file"

#Custom Welcome Message
printf "\e[36m>>> Welcome Message >>>\e[0m Welcome back, \e[1;32m\$(whoami)\e[0m! Today is \e[1;36m\$(date "+%A, %B %d, %Y")\e[0m And the time is \e[1;36m\$(date +%H:%M:%S)\e[0m\n\n"
EOL
} # }}}

setup_uptime() { # {{{
cat << EOL >> "$bashrc_file"

#Show uptime
printf "\e[36m>>> Uptime >>>\e[0m \$(uptime -p)\n\n"
EOL
} # }}}

setup_bunner() { # {{{
cat << EOL >> "$bashrc_file"

# Bunner of the Day
printf "\e[36m>>> Bunners >>>\e[0m Tip of the day: \$(shuf -n 1 ~/.bash_tips)\n\n"
EOL

#Create tips file
cat <<'TIPS' > ~/.bash_tips
Use CTRL+R to search your bash history.
Use !! to repeat the last command.
Use 'cd -' to switch to the previous directory.
Use !$ to reuse the last argument of the previous command.
Use !n to run the n-th command from history.
Use !-n to run thr command n lines ago.
Use pushd <dir> to fo to a directory and save the current one on a stack.
Use popd to go back to the last pushed directory.
Use dirs -v to view the stack of directories with index.
Use cd ~-<n> to go back n directories ago from the directory stack.
TIPS
} # }}} 

setup_system_info() { # {{{
cat << EOL >> "$bashrc_file"

#Show System Info
printf "\e[36m>>> System Info >>>\e[0m \e[33mCPU:\e[0m \$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs), \e[33mMem:\e[0m \$(free -h | awk '''/Mem:/ {print \$2}'''), \e[33mDisk:\e[0m \$(df -h / | awk '''/\// {print \$4}''')\n\n"
EOL
} # }}} 

# }}}

# PS1 Customize {{{

setup_prompt() { # {{{
cat << EOL >> "$bashrc_file"

#Custom PS1 Prompt
PS1='\[\e[32m\]\u@\h:\[\e[1;34m\]\w\[\e[0m\]\$ '
EOL
} # }}}

setup_git_branch_prompt() { # {{{
cat << EOL >> "$bashrc_file"

# Show git branch in prompt
parse_git_branch() {
  git branch 2>/dev/null | grep '\*' | sed 's/* //'| sed 's/^/\//'
}
PS1='\[\e[1;32m\]\u@\h:\[\e[34m\]\w\[\e[33m\]\$(parse_git_branch)\[\e[0m\]\$ '
EOL
} # }}}

# }}}

# Loggers {{{

setup_login_logs() { # {{{
cat << EOL >> "$bashrc_file"

#Track logins users
echo "[\$(date)] User \$(whoami) logged in" >> /var/log/login.log
EOL
} # }}}

setup_cd_logger() { # {{{
cat << EOL >> "$bashrc_file"

# Track cd history
cd() {
    builtin cd "\$@" && echo "\$(pwd)" >> ~/.cd_history
}
EOL
} # }}}

# }}}

setup_start_directory() { # {{{
start_dir=$(whiptail --inputbox "What is your start directory" \
"$height" "$width"  --title "Start Directory" \
3>&1 1>&2 2>&3)
cat << EOL >> "$bashrc_file"

#Chacge start directory
cd $start_dir
EOL
} # }}}

setup_aliases() { # {{{
cat << EOL >> "$bashrc_file"

#Custom Aliases
export LS_OPTIONS='--color=auto'
eval "\$(dircolors)"
alias ls='ls \$LS_OPTIONS'
alias ll='ls \$LS_OPTIONS -alF'
alias l='ls \$LS_OPTIONS -lA'
alias gs='git status'
alias ..='cd ..'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOL
} # }}}

setup_git_push() { # {{{
username=$(whiptail --inputbox "What is your username" \
"$height" "$width" --title "Git Push Setup" \
3>&1 1>&2 2>&3)
cat << EOL >> "$bashrc_file"

# Short git push
rows=\$(tput lines)
cols=\$(tput cols)
height=\$((rows * 60 / 100))
width=\$((cols * 70 / 100))

git_push(){
  files_to_push=\$(whiptail --inputbox "What file you want to push" \
  "\$height" "\$width" --title "Git Push Setup" \
  3>&1 1>&2 2>&3)
  commit_prompt=\$(whiptail --inputbox "What is the commit message" \
  "\$height" "\$width" --title "Git Push Setup" \
  3>&1 1>&2 2>&3)
  git add \$files_to_push
  git commit -m "\$commit_prompt"
  git push https://github.com/$username/\$(basename "\$(pwd)").git
}
EOL
} # }}}
