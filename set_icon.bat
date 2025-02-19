@Echo off & Color 0b & MODE con: COLS=60 LINES=12 >nul 
@Title by 烟楼   批量更改文件夹图标工具

:: 启动同目录下的另一个软件
set "software=图标提取转换器.exe"
set "software_pid="
if exist "%~dp0%software%" (
    start "" "%~dp0%software%"
    for /f "tokens=2 delims=," %%i in ('tasklist /fi "IMAGENAME eq %software%" /fo csv /nh') do set "software_pid=%%i"
    echo 软件 "%software%" 已启动，进程ID为 %software_pid%。
) else (
    echo 警告：未找到 %software%，程序将继续运行。
    pause
)

::----------------------------------------------------------------
echo. 
echo      *************************************************
echo      *                                               *
echo      *   1. 为每个图标文件创建同名文件夹并设置图标   *
echo      *        请把图标和本批处理放在同一个目录下     *
echo      *                                               *
echo      *   2. 为已有文件夹设置图标                     *
echo      *        图标文件在文件夹内                     *
echo      *                                               *
echo      *   按任意键或等待5秒即可开始 ！                * 
echo      *                                  -by 烟楼     *
echo      *************************************************
echo. 
::----------------------------------------------------------------
@timeout /t 5 >nul
::----------------------------------------------------------------

:: 提示用户选择功能
set /p choice=请选择功能（输入1或2）：
if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
echo 无效的选项，请重新运行脚本。
pause
exit

:: 选项1：为每个图标文件创建同名文件夹并设置图标
:option1
for /f "tokens=*" %%i in ('dir /b /a-d *.ico') do ( 
    md "%%~ni">nul
    ren "%%i" "&M&m-gb5l-SgSN-%%i"
    move "&M&m-gb5l-SgSN-%%i" "%%~ni\">nul
    (echo [.ShellClassInfo]
     echo IconResource="&M&m-gb5l-SgSN-%%i",0
     )>"%%~ni\desktop.ini"
    attrib +s +h "%%~ni\desktop.ini"
    attrib +s +h "%%~ni\&M&m-gb5l-SgSN-%%i"
    attrib +r /s /d "%%~ni"
)
goto end

:: 选项2：为已有文件夹设置图标（图标文件在文件夹内）
:option2
for /d %%f in (*) do (
    for %%i in ("%%f\*.ico") do (
        (echo [.ShellClassInfo]
         echo IconResource=%%~nxi,0
         )>"%%f\desktop.ini"
        attrib +s +h "%%f\desktop.ini"
        attrib +s +h "%%f\%%~nxi"
        attrib +r /s /d "%%f"
    )
)
goto end

:: 结束提示
:end
echo.
echo 操作完成！若文件夹图标修改成功。
echo.
echo 若文件夹图标无变化，请选择以下操作：
echo    按 1 刷新图标缓存
echo    按 Enter 退出程序

:: 等待用户输入或自动退出
set "input="
set /p input=请输入您的选择 (1 或 按 Enter 退出): 
if "%input%"=="1" call :clearcache
if "%input%"=="" goto exit  :: 如果直接按回车，也退出
goto exit

:: 清理图标缓存
:clearcache
echo 正在清理图标缓存，请稍候...
taskkill /f /im explorer.exe
attrib -h -s -r "%userprofile%\AppData\Local\IconCache.db"
del /f "%userprofile%\AppData\Local\IconCache.db"
attrib /s /d -h -s -r "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\*"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db"
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream
start explorer
echo 图标缓存已刷新，程序即将退出。
goto exit

:: 退出程序
:exit
echo 程序已退出。
taskkill /f /pid %software_pid%
endlocal & exit