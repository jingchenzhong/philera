#export XIM="SCIM"
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#scim -d
xset -b b 0
export LC_CTYPE="zh_CN.UTF-8"
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
fcitx &
#exec dwm
exec awesome 

