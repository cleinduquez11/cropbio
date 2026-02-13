@echo off


net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell start-process cmd -ArgumentList '/c, %~s0' -verb runAs
    exit /b
)


echo Running Python script as Administrator... 
python %~dp0setup.py


echo Productivity System API is running....

python %~dp0api.py
