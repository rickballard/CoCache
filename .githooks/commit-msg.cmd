@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0commit-msg.ps1" "%~1"
