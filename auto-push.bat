@echo off
REM Script untuk auto add, commit, dan push perubahan file
REM Usage: auto-push.bat [commit message]

setlocal enabledelayedexpansion

REM Cek apakah ada perubahan
git status --porcelain >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Bukan direktori git repository
    pause
    exit /b 1
)

REM Cek apakah ada perubahan untuk di-commit
git diff --quiet && git diff --cached --quiet
if %errorlevel% equ 0 (
    echo Tidak ada perubahan untuk di-commit.
    pause
    exit /b 0
)

REM Ambil commit message dari parameter atau gunakan default
set "commit_msg=%~1"
if "!commit_msg!"=="" (
    set "commit_msg=Auto commit: %date% %time%"
)

echo ========================================
echo Auto Git Push Script
echo ========================================
echo.

REM Step 1: Add semua perubahan
echo [1/3] Menambahkan semua perubahan...
git add .
if errorlevel 1 (
    echo Error: Gagal menambahkan file
    pause
    exit /b 1
)
echo OK - File berhasil ditambahkan
echo.

REM Step 2: Commit
echo [2/3] Melakukan commit...
git commit -m "!commit_msg!"
if errorlevel 1 (
    echo Error: Gagal melakukan commit
    pause
    exit /b 1
)
echo OK - Commit berhasil
echo.

REM Step 3: Push ke remote
echo [3/3] Push ke remote repository...
git push origin main
if errorlevel 1 (
    echo.
    echo Warning: Push gagal. Mencoba push ke branch saat ini...
    for /f "delims=" %%b in ('git symbolic-ref --short HEAD') do set branch=%%b
    git push origin !branch!
    if errorlevel 1 (
        echo Error: Gagal melakukan push
        pause
        exit /b 1
    )
)
echo OK - Push berhasil
echo.

echo ========================================
echo Semua operasi selesai!
echo ========================================
pause

