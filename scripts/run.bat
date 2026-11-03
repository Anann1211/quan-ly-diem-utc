@echo off
chcp 65001 > nul
cd /d "%~dp0\.."
echo ==========================================================
echo   TRƯỜNG ĐẠI HỌC GIAO THÔNG VẬN TẢI - UTC GRADE MANAGEMENT
echo   CSDL: Oracle Database 23ai Free (FREEPDB1)
echo ==========================================================
call mvn compile exec:java
pause
