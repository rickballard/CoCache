@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0pre-push.ps1" %*
