param(
    [string]$EnvName = "any-auto-register",
    [string]$BindHost = "0.0.0.0",
    [int]$Port = 8000
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$conda = Get-Command conda -ErrorAction SilentlyContinue
if (-not $conda) {
    Write-Error "未找到 conda 命令。请先安装 Miniconda/Anaconda，并确保 conda 可在终端中使用。"
    exit 1
}

Write-Host "[INFO] 项目目录: $root"
Write-Host "[INFO] 使用 conda 环境: $EnvName"
Write-Host "[INFO] 启动后端: http://localhost:$Port"
Write-Host "[INFO] 按 Ctrl+C 可停止服务"

$pythonExe = (conda run --no-capture-output -n $EnvName python -c "import sys; print(sys.executable)").Trim()
if (-not (Test-Path $pythonExe)) {
    Write-Error "无法解析 conda 环境 '$EnvName' 对应的 python 路径。"
    exit 1
}

$env:HOST = $BindHost
$env:PORT = [string]$Port

Write-Host "[INFO] Python: $pythonExe"
& $pythonExe main.py
