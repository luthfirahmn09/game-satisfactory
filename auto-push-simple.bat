@echo off
REM Script sederhana untuk auto add, commit, dan push
REM Menggunakan commit message otomatis dengan timestamp

echo Auto pushing changes...

git add .
git commit -m "Auto commit: %date% %time%"
git push origin main

if errorlevel 1 (
    echo Push ke main gagal, mencoba branch saat ini...
    for /f "delims=" %%b in ('git symbolic-ref --short HEAD') do git push origin %%b
)

echo Selesai!
pause

