@echo off
setlocal

set "ENV_NAME=%APP_CONDA_ENV%"
if "%ENV_NAME%"=="" set "ENV_NAME=any-auto-register"
set "HOST=%HOST%"
if "%HOST%"=="" set "HOST=0.0.0.0"
set "PORT=%PORT%"
if "%PORT%"=="" set "PORT=8000"

where conda >nul 2>nul
if errorlevel 1 (
  echo [ERROR] 未找到 conda 命令。请先安装 Miniconda/Anaconda，并确保 conda 可在终端中使用。
  exit /b 1
)

cd /d "%~dp0"
echo [INFO] 项目目录: %CD%
echo [INFO] 使用 conda 环境: %ENV_NAME%
echo [INFO] 启动后端: http://localhost:%PORT%
echo [INFO] 按 Ctrl+C 可停止服务

for /f "usebackq delims=" %%i in (`conda run --no-capture-output -n %ENV_NAME% python -c "import sys; print(sys.executable)"`) do set "PYTHON_EXE=%%i"

if not exist "%PYTHON_EXE%" (
  echo [ERROR] 无法解析 conda 环境 "%ENV_NAME%" 对应的 python 路径。
  exit /b 1
)

set "HOST=%HOST%"
set "PORT=%PORT%"
echo [INFO] Python: %PYTHON_EXE%
"%PYTHON_EXE%" main.py
