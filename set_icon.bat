@Echo off & Color 0b & MODE con: COLS=60 LINES=12 >nul 
@Title by ��¥   ���������ļ���ͼ�깤��

:: ����ͬĿ¼�µ���һ�����
set "software=ͼ����ȡת����.exe"
set "software_pid="
if exist "%~dp0%software%" (
    start "" "%~dp0%software%"
    for /f "tokens=2 delims=," %%i in ('tasklist /fi "IMAGENAME eq %software%" /fo csv /nh') do set "software_pid=%%i"
    echo ��� "%software%" ������������IDΪ %software_pid%��
) else (
    echo ���棺δ�ҵ� %software%�����򽫼������С�
    pause
)

::----------------------------------------------------------------
echo. 
echo      *************************************************
echo      *                                               *
echo      *   1. Ϊÿ��ͼ���ļ�����ͬ���ļ��в�����ͼ��   *
echo      *        ���ͼ��ͱ����������ͬһ��Ŀ¼��     *
echo      *                                               *
echo      *   2. Ϊ�����ļ�������ͼ��                     *
echo      *        ͼ���ļ����ļ�����                     *
echo      *                                               *
echo      *   ���������ȴ�5�뼴�ɿ�ʼ ��                * 
echo      *                                  -by ��¥     *
echo      *************************************************
echo. 
::----------------------------------------------------------------
@timeout /t 5 >nul
::----------------------------------------------------------------

:: ��ʾ�û�ѡ����
set /p choice=��ѡ���ܣ�����1��2����
if "%choice%"=="1" goto option1
if "%choice%"=="2" goto option2
echo ��Ч��ѡ����������нű���
pause
exit

:: ѡ��1��Ϊÿ��ͼ���ļ�����ͬ���ļ��в�����ͼ��
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

:: ѡ��2��Ϊ�����ļ�������ͼ�꣨ͼ���ļ����ļ����ڣ�
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

:: ������ʾ
:end
echo.
echo ������ɣ����ļ���ͼ���޸ĳɹ���
echo.
echo ���ļ���ͼ���ޱ仯����ѡ�����²�����
echo    �� 1 ˢ��ͼ�껺��
echo    �� Enter �˳�����

:: �ȴ��û�������Զ��˳�
set "input="
set /p input=����������ѡ�� (1 �� �� Enter �˳�): 
if "%input%"=="1" call :clearcache
if "%input%"=="" goto exit  :: ���ֱ�Ӱ��س���Ҳ�˳�
goto exit

:: ����ͼ�껺��
:clearcache
echo ��������ͼ�껺�棬���Ժ�...
taskkill /f /im explorer.exe
attrib -h -s -r "%userprofile%\AppData\Local\IconCache.db"
del /f "%userprofile%\AppData\Local\IconCache.db"
attrib /s /d -h -s -r "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\*"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db"
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream
start explorer
echo ͼ�껺����ˢ�£����򼴽��˳���
goto exit

:: �˳�����
:exit
echo �������˳���
taskkill /f /pid %software_pid%
endlocal & exit