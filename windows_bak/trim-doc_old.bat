@echo off
setlocal ENABLEEXTENSIONS
set d1=%date:~5,2%
set d2=%date:~8,2%
set t1=%time:~0,2%
set t2=%time:~3,2%
set p=%d1%%d2%
echo %p%
set destdir="E:\mybackup\temp\%p%\"
if not exist %destdir% md %destdir%
::pause
for %%i in ("*.jar,*.py,*.psd","*.ord","*.ver","*.apk","*.ipa","*.log","*.php","*.class","*.db","*.xlsx","*.xls","*.doc","*.docx","*.txt","*.pdf","*.pptx","*.ppt","*.rar","*.png","*.jpg","*.csv","*.sh","*.xml","*.prn","*.sql","*.json","*.html","*.zip") do ( 
copy "%%i" "%destdir%" /y 
del "%%i"
)
copy *.bat "%destdir%" /y 
@echo Trim Over
@echo 等待一秒后自动关闭
@ping 2.2.2 -w 480 -n 2 >nul
explorer %destdir%
exit