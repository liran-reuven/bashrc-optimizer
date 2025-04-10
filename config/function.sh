# Functions

setup_welcome() { # {{{
cat << EOL >> "$bashrc_file"

#Custom Welcome Message
printf "\$(date) Welcome \$(whoami)!\n"
EOL
} # }}}

setup_aliases() { # {{{
cat << EOL >> "$bashrc_file"

#Custom Aliases
export LS_OPTIONS='--color=auto'
eval "\$(dircolors)"
alias ls='ls \$LS_OPTIONS'
# alias ll='ls \$LS_OPTIONS -l'
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

setup_prompt() { # {{{
cat << EOL >> "$bashrc_file"

#Custom PS1 Prompt
PS1='\[\e[32m\]\u@\h:\[\e[34m\]\w\[\e[0m\]\$ '
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

setup_bunner() { # {{{
cat << EOL >> "$bashrc_file"

# Banner of the Day
echo "Tip of the day:"
shuf -n 1 ~/.bash_tips
EOL

#Create tips file
cat <<'TIPS' > ~/.bash_tips
Use CTRL+R to search your bash history.
Use !! to repeat the last command.
Use 'cd -' to switch to the previous directory.
TIPS
 } # }}} 

setup_git_branch_prompt() { # {{{
cat << EOL >> "$bashrc_file"

# Show git branch in prompt
parse_git_branch() {
  git branch 2>/dev/null | grep '\*' | sed 's/* //'
}
PS1='\[\e[32m\]\u@\h:\[\e[34m\]\w\[\e[33m\]\$(parse_git_branch)\[\e[0m\]\$ '
EOL
} # }}}
