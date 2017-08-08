@echo off
setlocal ENABLEEXTENSIONS
set ye=%date:~0,4%
set d1=%date:~5,2%
set d2=%date:~8,2%
set t1=%time:~0,2%
set t2=%time:~3,2%
set p=%d1%%d2%
echo %ye%%p%

set destdir="E:\mybackup\temp\%ye%%p%\"
if not exist %destdir% md %destdir%
if not exist %destdir%\word\ md %destdir%\word\
if not exist %destdir%\excel\ md %destdir%\excel\
if not exist %destdir%\txt\ md %destdir%\txt\
if not exist %destdir%\pdf\ md %destdir%\pdf\
if not exist %destdir%\ppt\ md %destdir%\ppt\
if not exist %destdir%\others\ md %destdir%\others\

if exist "*.doc" (
copy "*.doc"  "%destdir%\word\"
del "*.doc"
)
if exist "*.docx" (
copy "*.docx"  "%destdir%\word\"
del "*.docx"
)
if exist "*.xls" (
copy "*.xls"  "%destdir%\excel\"
del "*.xls"
)
if exist "*.xlsx" (
copy "*.xlsx"  "%destdir%\excel\"
del "*.xlsx"
)
if exist "*.ppt" (
copy "*.ppt"  "%destdir%\ppt\"
del "*.ppt"
)
if exist "*.pptx" (
copy "*.pptx"  "%destdir%\ppt\"
del "*.pptx"
)
if exist "*.txt" (
copy "*.txt"  "%destdir%\txt\"
del "*.txt"
)
if exist "*.pdf" (
copy "*.pdf"  "%destdir%\pdf\"
del "*.pdf"
)

::pause word excel ppt txt other
for %%i in ("*.jar","*.jpeg","*.exe","*.vsd","*.msi","*.py","*.psd","*.sql","*.class","*.tar.gz","*.tar","*.db","*.exe","*.rar","*.png","*.jpg","*.csv","*.sh","*.xml","*.html","*.zip","*.avi","*.wmv","*.rmvb","*.mp4","*.rm","*.mp3") do ( 
if exist "%%i" (
copy "%%i" "%destdir%\others" /y 
del "%%i"
)
)
copy *.bat "%destdir%" /y 

@echo Trim Over
@echo 等待一秒后自动关闭
@ping 2.2.2 -w 480 -n 2 >nul
explorer %destdir%
exit