@echo off
setlocal

set "BACKEND_PORT=%BACKEND_PORT%"
if "%BACKEND_PORT%"=="" set "BACKEND_PORT=8000"
set "SOLVER_PORT=%SOLVER_PORT%"
if "%SOLVER_PORT%"=="" set "SOLVER_PORT=8889"

echo [INFO] 准备停止端口: %BACKEND_PORT%, %SOLVER_PORT%
powershell -ExecutionPolicy Bypass -File "%~dp0stop_backend.ps1" -BackendPort %BACKEND_PORT% -SolverPort %SOLVER_PORT%
