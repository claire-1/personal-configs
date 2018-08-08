#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

parse_git_branch() {
      git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#PS1="\u@\h \[\033[0;91m\]\w\[\033[0;93m\]\$(parse_git_branch)\[\033[00m\] $ "
PS1="${debian_chroot:+($debian_chroot)}\[\033[0;91m\]\u@\h\[\033[00m\]\$(parse_git_branch):\[\033[0;97m\]\w\[\033[00m\]\$ "
# PS1='[\u@\h \W]\$ '

alias ll='ls -alF'
alias ls='ls --color=auto'
alias vls='valgrind --leak-check=yes'

