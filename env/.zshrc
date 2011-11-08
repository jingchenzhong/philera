#color{{{
autoload colors 
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
#}}}

#������ʾ�� {{{
#RPROMPT=$(echo "$RED%D %T$FINISH")
#PROMPT=$(echo "$BLUE%M$GREEN%/
#$CYAN%n $_YELLOW>>>$FINISH ")

#�߿�����ʾ��

function precmd {

local TERMWIDTH
(( TERMWIDTH = ${COLUMNS} - 1 ))


###
# ���·��̫�����ض���

FILLBAR=""
PWDLEN=""

#ͳ�� %~ ˫�ֽ��ַ�
local count_db_wth_char="$( echo ${^${(%):-%~}} | sed 's/\(.\)/\1\n/g' | grep -c \[\^\!-\~\] )"
local promptsize=${#${(%):---(%n@%m:%l)---()--}}
local pwdsize=${#${(%):-%~}}+$count_db_wth_char

if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
((PWDLEN=$TERMWIDTH - $promptsize))
else
FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${HBAR}.)}"
fi


###
# Get APM info.

#if which ibam > /dev/null; then
#APM_RESULT=`ibam --percentbattery`
#elif which apm > /dev/null; then
#APM_RESULT=`apm`
#fi
}


setopt extended_glob
preexec () {
if [[ "$TERM" == "screen" ]]; then
local CMD=${1[(wr)^(*=*|sudo|-*)]}
echo -n "\ek$CMD\e\\"
fi
}

setprompt () {
###
# Need this so the prompt will work.

setopt prompt_subst


###
# See if we can use colors.

autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval $color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval LIGHT_$color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
NO_COLOUR="%{$terminfo[sgr0]%}"


###
# See if we can use extended characters to look nicer.

typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}
SET_CHARSET="%{$terminfo[enacs]%}"
SHIFT_IN="%{$terminfo[smacs]%}"
SHIFT_OUT="%{$terminfo[rmacs]%}"
HBAR=${altchar[q]:--}
#HBAR=" "
ULCORNER=${altchar[l]:--}
LLCORNER=${altchar[m]:--}
LRCORNER=${altchar[j]:--}
URCORNER=${altchar[k]:--}


###
# Decide if we need to set titlebar text.

case $TERM in
xterm*)
TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
;;
screen)
TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
;;
*)
TITLEBAR=''
;;
esac


###
# Decide whether to set a screen title
if [[ "$TERM" == "screen" ]]; then
STITLE=$'%{\ekzsh\e\\%}'
else
STITLE=''
fi


###
# APM detection

#if which ibam > /dev/null; then
#APM='$RED${${APM_RESULT[(f)1]}[(w)-2]}%%(${${APM_RESULT[(f)3]}[(w)-1]})$LIGHT_BLUE:'
#elif which apm > /dev/null; then
#APM='$RED${APM_RESULT[(w)5,(w)6]/\% /%%}$LIGHT_BLUE:'
#else
APM=''
#fi


###
# Finally, the prompt.

PROMPT='$SET_CHARSET$STITLE${(e)TITLEBAR}\
$CYAN$SHIFT_IN$ULCORNER$BLUE$HBAR$SHIFT_OUT(\
$GREEN%(!.%SROOT%s.%n)$GREEN@%m:%l\
$BLUE)$SHIFT_IN$HBAR$CYAN$HBAR${(e)FILLBAR}$BLUE$HBAR$SHIFT_OUT(\
$MAGENTA%$PWDLEN<...<%~%<<\
$BLUE)$SHIFT_IN$HBAR$CYAN$URCORNER$SHIFT_OUT\

$CYAN$SHIFT_IN$LLCORNER$BLUE$HBAR$SHIFT_OUT(\
%(?..$LIGHT_RED%?$BLUE:)\
${(e)APM}$YELLOW%D{%H:%M}\
$LIGHT_BLUE:%(!.$RED.$WHITE)%#$BLUE)$SHIFT_IN$HBAR$SHIFT_OUT\
$CYAN$SHIFT_IN$HBAR$SHIFT_OUT\
$NO_COLOUR '

RPROMPT=' $CYAN$SHIFT_IN$HBAR$BLUE$HBAR$SHIFT_OUT\
($YELLOW%D{%a,%b%d}$BLUE)$SHIFT_IN$HBAR$CYAN$LRCORNER$SHIFT_OUT$NO_COLOUR'

PS2='$CYAN$SHIFT_IN$HBAR$SHIFT_OUT\
$BLUE$SHIFT_IN$HBAR$SHIFT_OUT(\
$LIGHT_GREEN%_$BLUE)$SHIFT_IN$HBAR$SHIFT_OUT\
$CYAN$SHIFT_IN$HBAR$SHIFT_OUT$NO_COLOUR '
}

setprompt           


#}}}


#����������������ʽ{{{
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
   precmd () { print -Pn "\e]0;%n@%M//%/\a" }
   preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
   ;;
esac
#}}}

#������ʷ��¼������ {{{
#��ʷ��¼��Ŀ����
export HISTSIZE=10000
#ע���󱣴����ʷ��¼��Ŀ����
export SAVEHIST=10000
#��ʷ��¼�ļ�
#export HISTFILE=~/.zhistory
#�Ը��ӵķ�ʽд����ʷ��¼
setopt INC_APPEND_HISTORY
#������������������ͬ����ʷ��¼��ֻ����һ��
setopt HIST_IGNORE_DUPS      
#Ϊ��ʷ��¼�е��������ʱ���      
setopt EXTENDED_HISTORY      

#���� cd �������ʷ��¼��cd -[TAB]������ʷ·��
setopt AUTO_PUSHD
#��ͬ����ʷ·��ֻ����һ��
setopt PUSHD_IGNORE_DUPS

#������ǰ��ӿո񣬲�����������ӵ���¼�ļ���
#setopt HIST_IGNORE_SPACE      
#}}}

#ÿ��Ŀ¼ʹ�ö�������ʷ��¼{{{
cd() {
    builtin cd "$@"                             # do actual cd
    fc -W                                       # write current history  file
    local HISTDIR="$HOME/.zsh_history$PWD"      # use nested folders for history
        if  [ ! -d "$HISTDIR" ] ; then          # create folder if needed
            mkdir -p "$HISTDIR"
        fi
        export HISTFILE="$HISTDIR/zhistory"     # set new history file
    touch $HISTFILE
    local ohistsize=$HISTSIZE
        HISTSIZE=0                              # Discard previous dir's history
        HISTSIZE=$ohistsize                     # Prepare for new dir's history
    fc -R                                       #read from current histfile
}
mkdir -p $HOME/.zsh_history$PWD
export HISTFILE="$HOME/.zsh_history$PWD/zhistory"

function allhistory { cat $(find $HOME/.zsh_history -name zhistory) }
function convhistory {
            sort $1 | uniq |
            sed 's/^:\([ 0-9]*\):[0-9]*;\(.*\)/\1::::::\2/' |
            awk -F"::::::" '{ $1=strftime("%Y-%m-%d %T",$1) "|"; print }'  
}
#ʹ�� histall ����鿴ȫ����ʷ��¼
function histall { convhistory =(allhistory) |
            sed '/^.\{20\} *cd/i\\' }
#ʹ�� hist �鿴��ǰĿ¼��ʷ��¼
function hist { convhistory $HISTFILE }

#ȫ����ʷ��¼ top44
function top44 { allhistory | awk -F':[ 0-9]*:[0-9]*;' '{ $1="" ; print }' | sed 's/ /\n/g' | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 44 }

#}}}

#���� {{{
#�����ڽ���ģʽ��ʹ��ע��  ���磺
#cmd #����ע��
setopt INTERACTIVE_COMMENTS      
      
#�����Զ� cd������Ŀ¼���س�����Ŀ¼
#��΢�е���ң����� cd ��ȫʵ��
#setopt AUTO_CD
      
#��չ·��
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word
      
#���� core dumps
limit coredumpsize 0

#Emacs��� ����
bindkey -e
#���� [DEL]�� Ϊ���ɾ��
bindkey "\e[3~" delete-char

#�����ַ���Ϊ���ʵ�һ����
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

#�Զ���ȫ���� {{{
setopt AUTO_LIST
setopt AUTO_MENU
#������ѡ���ȫʱ��ֱ��ѡ�в˵���
#setopt MENU_COMPLETE

autoload -U compinit
compinit

#�Զ���ȫ����
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#�Զ���ȫѡ��
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

#·����ȫ
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#��ɫ��ȫ�˵� 
eval $(dircolors -b) 
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#������Сд
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#����У��      
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#kill ���ȫ      
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

#��ȫ������ʾ���� 
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ ��ȫ˳��
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}

##�б༭����ģʽ {{{
# Ctrl+@ ���ñ�ǣ���Ǻ͹���֮��Ϊ region
zle_highlight=(region:bg=magenta #ѡ������ 
               special:bold      #�����ַ�
               isearch:underline)#����ʱʹ�õĹؼ���
#}}}

##����(���������)��ȫ "cd " {{{
user-complete(){
    case $BUFFER in
        "" )                       # �������� "cd "
            BUFFER="cd "
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd --" )                  # "cd --" �滻Ϊ "cd +"
            BUFFER="cd +"
            zle end-of-line
            zle expand-or-complete
            ;;
        "cd +-" )                  # "cd +-" �滻Ϊ "cd -"
            BUFFER="cd -"
            zle end-of-line
            zle expand-or-complete
            ;;
        * )
            zle expand-or-complete
            ;;
    esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}

##������ǰ���� sudo {{{
#���幦�� 
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line                 #����ƶ�����ĩ
}
zle -N sudo-command-line
#�����ݼ�Ϊ�� [Esc] [Esc]
bindkey "\e\e" sudo-command-line
#}}}
  
#������� {{{
alias -g cp='cp -iv'
alias -g mv='mv -iv'
#alias -g rm='rm -iv'
alias -g ls='ls -F --color=auto -a'
alias -g ll='ls -a -l'
alias -g grep='grep --color=auto'
alias -g ee='emacsclient -t'

#[Esc][h] man ��ǰ����ʱ����ʾ���˵�� 
alias run-help >&/dev/null && unalias run-help
autoload run-help

#��ʷ���� top10
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

#·������ {{{
#������Ӧ��·��ʱֻҪ cd ~xxx
hash -d WWW="/home/lighttpd/html"
hash -d ARCH="/mnt/arch"
hash -d PKG="/var/cache/pacman/pkg"
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I="/etc/rc.d"
hash -d X="/etc/X11"
hash -d BK="/home/r00t/config_bak"
#}}}
    
##for Emacs {{{
#�� Emacs�ն� ��ʹ�� Zsh ��һЩ���� ���Ƽ��� Emacs ��ʹ����
if [[ "$TERM" == "dumb" ]]; then
setopt No_zle
PROMPT='%n@%M %/
>>'
alias ls='ls -F'
fi 	
#}}}

#{{{�Զ��岹ȫ
#��ȫ ping
zstyle ':completion:*:ping:*' hosts 192.168.128.1{38,} www.g.cn \
       192.168.{1,0}.1{{7..9},}

#��ȫ ssh scp sftp ��
my_accounts=(
{r00t,root}@{192.168.1.1,192.168.0.1}
kardinal@linuxtoy.org
123@211.148.131.7
)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts
#}}}

#{{{ F1 ������
arith-eval-echo() {
  LBUFFER="${LBUFFER}echo \$(( "
  RBUFFER=" ))$RBUFFER"
}
zle -N arith-eval-echo
bindkey "^[[11~" arith-eval-echo
#}}}

####{{{
function timeconv { date -d @$1 +"%Y-%m-%d %T" }

# }}}


## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4 

