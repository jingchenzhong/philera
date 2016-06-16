eval `dbus-launch --sh-syntax --exit-with-session`
xset -b b 0
export LC_CTYPE="zh_CN.UTF-8"

#export GTK_IM_MODULE="scim"
#export QT_IM_MODULE="scim"
#export XMODIFIERS="@im=scim"
#killall scim
#scim -d


export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
killall fcitx
fcitx&

export OPERAPLUGINWRAPPER_PRIORITY=0
export OPERA_KEEP_BLOCKED_PLUGIN=0

killall startdict
stardict -h &

#calendar notify
killall remind
remind -z -k'gxmessage -title "reminder" %s &' ~/.reminders &

#vmware-user-suid-wrapper&
#conky &

#exec dwm
#exec awesome 
startlxde

