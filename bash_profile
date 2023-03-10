[ -f /etc/profile ] && source /etc/profile
export PAGER=less
export LESS="-IMSx4 -FJXR"
PS1='[\t][\j][\u@\h:\W]\$ '
export PS1
PROMPT_COMMAND='history -a'
export PROMPT_COMMAND
HISTTIMEFORMAT="%F %T "
export HISTTIMEFORMAT
HISTSIZE=20000
export HISTSIZE
HISTFILESIZE=20000
export HISTFILESIZE
