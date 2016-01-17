@ECHO off
cd /d %~dp0
echo %~f0
if "%1" == "h" goto begin 
mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit 
:begin 
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' ( 
goto UACPrompt 
) else ( goto gotAdmin ) 

:UACPrompt 
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs" 
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs" 

"%temp%\getadmin.vbs" 
exit /B 

:gotAdmin 
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" ) 
pushd "%CD%" 
CD /D "%~dp0" 
call chnroutes_up_netsh.bat > NUL
start shadowvpn.exe -c client.conf -s start -v
:shadow
tasklist|findstr /i "shadowvpn.exe"  > NUL || call chnroutes_down_netsh.bat > NUL && exit
ping 127.1 -n 1 >nul 2>nul
goto shadow