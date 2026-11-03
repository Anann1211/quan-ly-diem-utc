# PowerShell Script khởi chạy UTC Grade Management System
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path "$ScriptDir\.."
Set-Location $ProjectRoot

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI - UTC GRADE MANAGEMENT" -ForegroundColor Green
Write-Host "  CSDL: Oracle Database 23ai Free (FREEPDB1)" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

mvn compile exec:java
