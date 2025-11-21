@echo off
REM Script sederhana untuk auto pull dari remote repository

echo Auto pulling changes...

REM Fetch dan pull dari branch saat ini
git fetch origin
git pull

if errorlevel 1 (
    echo Pull gagal!
    pause
    exit /b 1
)

echo Pull berhasil!
pause

