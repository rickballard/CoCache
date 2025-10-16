@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0pre-commit.ps1" %*
