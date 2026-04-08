@echo off

echo Activating Conda environment...

REM Initialize Conda (change path if your Anaconda/Miniconda is installed elsewhere)
call "C:\Anaconda\Scripts\activate.bat"

REM Activate your environment (replace env_name with your actual env)
call conda activate coaster_py_env

echo CropBiodiversity Backend System API is running in production mode....

python "%~dp0runProd.py"

pause