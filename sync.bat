@echo off
REM This script provides a menu to either sync an existing Git repository
REM or clone a new one.

TITLE Git Sync & Clone Tool

:menu
cls
echo =======================================================
echo.
echo           Git Sync & Clone Tool
echo.
echo =======================================================
echo.
echo What would you like to do?
echo.
echo   1. Sync this folder with GitHub
echo   2. Clone a new repository from GitHub
echo   3. Exit
echo.

CHOICE /C 123 /M "Enter your choice: "

IF ERRORLEVEL 3 GOTO end
IF ERRORLEVEL 2 GOTO clone
IF ERRORLEVEL 1 GOTO sync

:sync
cls
echo =======================================================
echo.
echo           Syncing Folder with GitHub
echo.
echo =======================================================
echo.

REM Check if the current directory is a Git repository before proceeding.
IF NOT EXIST ".git" (
    echo [ERROR] This folder is not a Git repository.
    echo You need to clone a repository before you can sync.
    echo.
    pause
    GOTO menu
)

REM [1/5] Add all files in the current directory to the staging area.
echo [1/5] Staging all files...
git add .
echo.

REM [2/5] Commit the changes with the current date and time as the message.
echo [2/5] Committing local changes...
git commit -m "Sync: %date% %time%"
echo.

REM [3/5] Pull the latest changes from the remote repository.
echo [3/5] Pulling latest changes from the server...
git pull --rebase
echo.

REM [4/5] Push the committed changes to the remote repository.
echo [4/5] Pushing your changes to the server...
git push
echo.

REM [5/5] Run Git's garbage collection to clean up and optimize.
echo [5/5] Performing repository maintenance...
git gc --prune=now --aggressive
echo.

echo =======================================================
echo.
echo           Sync and Optimize Complete!
echo.
echo =======================================================
echo.
pause
GOTO menu

:clone
cls
echo =======================================================
echo.
echo           Cloning a GitHub Repository
echo.
echo =======================================================
echo.

REM Set the repository URL directly, removing the need for user input.
set "repo_url=https://github.com/GitKentC/mcpe-server.git"

echo Cloning the mcpe-server repository...
echo %repo_url%
echo.

REM Execute the git clone command with the predefined URL.
git clone %repo_url%

echo.
echo =======================================================
echo.
echo      Repository cloned successfully!
echo.
echo =======================================================
echo.
pause
GOTO menu

:end
exit