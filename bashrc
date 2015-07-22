PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '

export SHELL="/bin/bash"
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
