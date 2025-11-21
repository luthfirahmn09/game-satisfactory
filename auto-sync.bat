@echo off
REM Script untuk sync: pull dulu, lalu push jika ada perubahan lokal
REM Usage: auto-sync.bat

setlocal enabledelayedexpansion

echo ========================================
echo Auto Git Sync Script
echo ========================================
echo Sync: Pull -^> Add -^> Commit -^> Push
echo.

REM Cek apakah ini git repository
git status --porcelain >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Bukan direktori git repository
    pause
    exit /b 1
)

REM Step 1: Pull dulu
echo [1/4] Pulling dari remote...
git fetch origin
for /f "delims=" %%b in ('git symbolic-ref --short HEAD') do set branch=%%b
git pull origin !branch!
if errorlevel 1 (
    echo Warning: Pull gagal atau ada konflik. Melanjutkan...
)
echo.

REM Cek apakah ada perubahan lokal setelah pull
git diff --quiet && git diff --cached --quiet
if %errorlevel% equ 0 (
    echo Tidak ada perubahan lokal untuk di-commit dan push.
    echo Repository sudah up-to-date.
    pause
    exit /b 0
)

REM Step 2: Add
echo [2/4] Menambahkan perubahan...
git add .
echo OK
echo.

REM Step 3: Commit
echo [3/4] Melakukan commit...
set "commit_msg=Auto sync: %date% %time%"
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo Warning: Commit gagal atau tidak ada perubahan baru
)
echo OK
echo.

REM Step 4: Push
echo [4/4] Pushing ke remote...
git push origin !branch!
if errorlevel 1 (
    echo Error: Push gagal
    pause
    exit /b 1
)
echo OK
echo.

echo ========================================
echo Sync selesai!
echo ========================================
pause

