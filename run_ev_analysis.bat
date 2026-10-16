@echo off
setlocal

cd /d "%~dp0"

python export_ev_analysis_results.py
exit /b %ERRORLEVEL%
