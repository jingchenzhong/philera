export LC_CTYPE="zh_CN.UTF-8"
export XIM="SCIM"
export XMODIFIERS=@im=SCIM
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="scim"
killall scim
scim -d
export OPERAPLUGINWRAPPER_PRIORITY=0
export OPERA_KEEP_BLOCKED_PLUGIN=0
#export XIM="FCITX"
#export XMODIFIERS=@im=FCITX
#export GTK_IM_MODULE="fcitx"
#export QT_IM_MODULE="fcitx"
xset -b b 0
#killall fcitx
#fcitx -d
killall startdict
stardict -h &
#vmware-user-suid-wrapper&
#conky &
#exec dwm
exec awesome 
#startlxde

