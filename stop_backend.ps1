param(
    [int]$BackendPort = 8000,
    [int]$SolverPort = 8889
)

$ErrorActionPreference = "Stop"
$ports = @($BackendPort, $SolverPort) | Select-Object -Unique

Write-Host "[INFO] 准备停止端口: $($ports -join ', ')"

$connections = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
    Where-Object { $_.LocalPort -in $ports } |
    Select-Object -ExpandProperty OwningProcess -Unique

if (-not $connections) {
    Write-Host "[INFO] 未发现需要停止的监听进程"
    exit 0
}

foreach ($procId in $connections) {
    try {
        Stop-Process -Id $procId -Force -ErrorAction Stop
        Write-Host "[OK] 已停止 PID=$procId"
    } catch {
        Write-Warning "停止 PID=$procId 失败: $($_.Exception.Message)"
    }
}

Write-Host "[INFO] 停止完成"
