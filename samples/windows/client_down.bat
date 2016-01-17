@ECHO off
REM example client down script for windows
REM will be executed when client is down

REM all key value pairs in ShadowVPN config file will be passed to this script
REM as environment variables, except password

REM user-defined variables
SET remote_tun_ip=10.7.0.1
SET dns_server=192.168.1.1
SET orig_intf="LAN"

REM revert ip settings
netsh interface ip set interface %orig_intf% ignoredefaultroutes=disabled > NUL
netsh interface ip set address name="%intf%" dhcp > NUL

REM revert routing table
ECHO Reverting default route
route delete 0.0.0.0 mask 128.0.0.0 %remote_tun_ip% > NUL
route delete 128.0.0.0 mask 128.0.0.0 %remote_tun_ip% > NUL
route delete %server% > NUL

REM revert dns server
netsh interface ip set dns name="%intf%" static %dns_server% > NUL
netsh interface ip set dns name="%orig_intf%" static %dns_server% > NUL

REM flush dns cache
ipconfig /flushdns > NUL
ECHO DNS cache flush

ECHO %0 done
