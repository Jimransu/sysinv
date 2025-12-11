<#
    SysInv.ps1
    --------------------
    1. Grab system info (hostname, IP addresses, OS version)
    2. List installed software and export to CSV
#>

Write-Host "=== SYSINV STARTED ===`n"

# ---------------------------------------------------------
# 1) SYSTEM INFORMATION
# ---------------------------------------------------------
Write-Host "===== SYSTEM INFORMATION ====="

$os = Get-CimInstance Win32_OperatingSystem
$hostname = $env:COMPUTERNAME

# Filter out 169.x.x.x and loopback
$ips = Get-NetIPAddress -AddressFamily IPv4 |
       Where-Object {
            $_.IPAddress -notlike "169.*" -and
            $_.IPAddress -ne "127.0.0.1"
       } |
       Select-Object -ExpandProperty IPAddress -Unique

Write-Host "Hostname     : $hostname"
Write-Host "OS Caption   : $($os.Caption)"
Write-Host "OS Version   : $($os.Version)"
Write-Host "IP Addresses :"
foreach ($ip in $ips) {
    Write-Host "  - $ip"
}

Write-Host "==============================`n"

# ---------------------------------------------------------
# 2) INSTALLED SOFTWARE
# ---------------------------------------------------------
Write-Host "===== INSTALLED SOFTWARE ====="
Write-Host "(This may take a few seconds...)`n"

$paths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$software = foreach ($path in $paths) {
    Get-ItemProperty -Path $path -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -and $_.DisplayName.Trim() -ne "" } |
    Select-Object DisplayName, DisplayVersion, Publisher
}

$software |
    Sort-Object DisplayName |
    Format-Table -AutoSize

# Export to CSV in same folder as script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outFile = Join-Path $scriptDir "SysInv_InstalledSoftware_$env:COMPUTERNAME.csv"

$software |
    Sort-Object DisplayName |
    Export-Csv -Path $outFile -NoTypeInformation

Write-Host "`nInstalled software exported to:"
Write-Host "  $outFile"

Write-Host "`n=== SYSINV COMPLETED ==="
