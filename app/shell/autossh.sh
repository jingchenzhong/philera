#!/usr/bin/expect --
#!/bin/sh
# autossh.sh
# SimpleSSHProxy
# Usage: autossh.sh [foo] [foo] [bindingIP:port] [foo] [username] [remoteHost] [password]

# get arguments
#set IPandPort [lrange $argv 2 2]
#set username [lrange $argv 4 4]
#set remoteHost [lrange $argv 5 5]
#set password [lrange $argv 6 6]

set IPandPort "1080"
set username "vpn1"
set remoteHost "ssh.inyun.in"
set password "chenguiwen"
spawn /usr/bin/ssh -D $IPandPort $username@$remoteHost;
set timeout 60;
expect "*password:*" {
        send "$password\r"; set timeout 4;
        expect "*password:*" { puts "WRONG_PASSWORD"; exit; }
}
interact {
    timeout 60 {
        send " \r";
    }
}
