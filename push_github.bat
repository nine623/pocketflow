@echo off
REM ===============================
REM PUSH TO GITHUB (SAFE VERSION)
REM ===============================

REM ===== รับ commit message =====
set /p COMMIT_MSG=Enter commit message: 

REM ===== เช็คว่ามีการเปลี่ยนแปลง =====
git status --porcelain > temp_status.txt
set FILE_CHANGED=

for /f %%i in (temp_status.txt) do (
    set FILE_CHANGED=1
)
del temp_status.txt

if not defined FILE_CHANGED (
    echo No changes to commit.
    pause
    exit /b
)

REM ===== add + commit + push =====
git add .
git commit -m "%COMMIT_MSG%"
git push

echo.
echo ✅ Push completed!
pause