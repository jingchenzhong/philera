#
export LC_CTYPE="zh_CN.UTF-8"

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#export XMODIFIERS="@im=scim"

export OPERAPLUGINWRAPPER_PRIORITY=0
export OPERA_KEEP_BLOCKED_PLUGIN=0

# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias vi='vim'
# prompt
# PS1='[\u@\h \W]\$ '
PS1='\[\e[0;32m\]\u\[\e[m\]\[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;32m\]'
#PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[0m\]'

# modified commands
alias diff='colordiff'
alias opera='opera -fullscreen -nolirc -nowin -noargb -nomail -nosession ' 
export GREP_COLOR="1;32"
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias ..='cd ..'
alias zhcon='zhcon --utf8'
alias fbterm='LC_CTYPE="zh_CN.UTF-8" fbterm'
export LESS="-R"
eval $(dircolors -b)

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'
alias openports='netstat --all --numeric --programs --inet'
alias pg='ps -Af | grep $1'

# privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudo vim'
    alias root='sudo su'
    alias reboot='sudo reboot'
    alias halt='sudo halt'
    alias update='sudo yaourt -Syua'
    alias netcfg='sudo netcfg2'
fi

# ls
alias ls='ls -a -hF --color=always'
alias lr='ls -R --color=always'
alias ll='ls -l --color=always'
alias la='ll -A'
alias lx='ll -BX'
alias lz='ll -rS'
alias lt='ll -rt'
alias lm='la | more'

# safety features
alias cp='cp -r -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'



# path
export PATH=/home/phil/priv/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk/jre
export BROWSER=w3m
export EDITOR=vim
#http_proxy="http://10.159.32.155:8080"
#http_proxy="http://10.144.1.10:8080"
#ftp_proxy=$http_proxy
#export http_proxy ftp_proxy
export TERM=xterm
export PAGER=less
export VISUAL=vim
export EDITOR=vim
export CDPATH="$HOME:$HOME/repos/:$HOME/mydoc"


# erase dup history
export HISTCONTROL=erasedups
# ignore command with space
export HISTCONTROL=ignorespace

complete -cf sudo
complete -cf man


