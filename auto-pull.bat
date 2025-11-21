@echo off
REM Script untuk auto pull dari remote repository
REM Usage: auto-pull.bat [branch]

setlocal enabledelayedexpansion

REM Cek apakah ini git repository
git status --porcelain >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Bukan direktori git repository
    pause
    exit /b 1
)

REM Ambil branch dari parameter atau gunakan branch saat ini
set "target_branch=%~1"
if "!target_branch!"=="" (
    for /f "delims=" %%b in ('git symbolic-ref --short HEAD') do set target_branch=%%b
)

echo ========================================
echo Auto Git Pull Script
echo ========================================
echo Branch: !target_branch!
echo.

REM Cek apakah ada perubahan lokal yang belum di-commit
git diff --quiet
if %errorlevel% neq 0 (
    echo Warning: Ada perubahan lokal yang belum di-commit
    echo.
    choice /C YN /M "Lanjutkan pull? Perubahan lokal mungkin akan di-overwrite (Y/N)"
    if errorlevel 2 (
        echo Pull dibatalkan
        pause
        exit /b 0
    )
    echo.
)

REM Fetch dulu untuk update informasi remote
echo [1/2] Fetching dari remote...
git fetch origin
if errorlevel 1 (
    echo Error: Gagal melakukan fetch
    pause
    exit /b 1
)
echo OK - Fetch berhasil
echo.

REM Pull dari remote
echo [2/2] Pulling dari origin/!target_branch!...
git pull origin !target_branch!
if errorlevel 1 (
    echo.
    echo Error: Pull gagal. Mungkin ada konflik atau masalah koneksi.
    echo.
    echo Tips:
    echo - Pastikan koneksi internet aktif
    echo - Cek apakah ada konflik yang perlu diselesaikan
    echo - Pastikan tidak ada perubahan lokal yang bertentangan
    pause
    exit /b 1
)
echo OK - Pull berhasil
echo.

REM Tampilkan status terakhir
echo ========================================
echo Status repository:
echo ========================================
git status --short
echo.

echo ========================================
echo Pull selesai!
echo ========================================
pause

