@echo off

echo Activating Conda environment...

REM Initialize Conda (change path if your Anaconda/Miniconda is installed elsewhere)
call "C:\Anaconda\Scripts\activate.bat"

REM Activate your environment (replace env_name with your actual env)
call conda activate cropbio-api

echo CropBiodiversity Backend System API is running in debug mode....

python "%~dp0runDebug.py"

pause