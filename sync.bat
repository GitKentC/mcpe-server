@echo off
REM This script provides a menu to push, pull, or clone a Git repository
REM using shallow history to save space.

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
echo   1. Pull (Download latest changes from GitHub)
echo   2. Push (Upload your local changes to GitHub)
echo   3. Clone a new repository from GitHub
echo   4. Exit
echo.

CHOICE /C 1234 /M "Enter your choice: "

IF ERRORLEVEL 4 GOTO end
IF ERRORLEVEL 3 GOTO clone
IF ERRORLEVEL 2 GOTO push
IF ERRORLEVEL 1 GOTO pull

:pull
cls
echo =======================================================
echo.
echo       Downloading Changes from GitHub (Pull)
echo.
echo =======================================================
echo.

REM Check if the current directory is a Git repository before proceeding.
IF NOT EXIST ".git" (
    echo [ERROR] This folder is not a Git repository.
    echo You need to clone a repository before you can pull.
    echo.
    pause
    GOTO menu
)

REM [1/2] Pull the latest changes from the remote repository.
REM Using --depth=1 ensures we don't download the entire project history.
echo [1/2] Pulling latest changes from the server (shallow)...
git pull --depth=1 --rebase
echo.

REM [2/2] Run Git's garbage collection to clean up and optimize.
echo [2/2] Performing repository maintenance...
git gc --prune=now --aggressive
echo.

echo =======================================================
echo.
echo                Pull Complete!
echo.
echo =======================================================
echo.
pause
GOTO menu

:push
cls
echo =======================================================
echo.
echo         Uploading Changes to GitHub (Push)
echo.
echo =======================================================
echo.

REM Check if the current directory is a Git repository before proceeding.
IF NOT EXIST ".git" (
    echo [ERROR] This folder is not a Git repository.
    echo You need to clone a repository before you can push.
    echo.
    pause
    GOTO menu
)

REM [1/3] Add all files in the current directory to the staging area.
echo [1/3] Staging all files...
git add .
echo.

REM [2/3] Commit the changes with the current date and time as the message.
echo [2/3] Committing local changes...
git commit -m "Sync: %date% %time%"
echo.

REM [3/3] Push the committed changes to the remote repository.
echo [3/3] Pushing your changes to the server...
git push
echo.

echo =======================================================
echo.
echo                Push Complete!
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

REM First, check if this is already a git repository.
IF EXIST ".git" (
    echo [ERROR] This folder is already a Git repository.
    echo You should use a 'Pull' or 'Push' option instead.
    echo.
    pause
    GOTO menu
)

REM Check if the directory contains more than just this script.
set "item_count=0"
for %%i in (*) do set /a item_count+=1
for /d %%i in (*) do set /a item_count+=1

REM The script itself counts as 1. If there's more, it's not empty enough.
if %item_count% GTR 1 (
    echo [ERROR] This folder is not empty.
    echo Git can only clone into an empty directory to avoid overwriting files.
    echo Please run this script in a new folder that contains nothing else.
    echo.
    pause
    GOTO menu
)

echo This will clone the repository's files into the current folder.
echo.

REM Set the repository URL directly, removing the need for user input.
set "repo_url=https://github.com/GitKentC/mcpe-server.git"

echo Cloning the mcpe-server repository into the current directory...
echo %repo_url%
echo.

REM Execute a shallow git clone (--depth 1) to only download the latest commit,
REM which significantly reduces the .git folder size.
git clone --depth 1 %repo_url% .

echo.
echo =======================================================
echo.
echo      Repository contents cloned successfully!
echo.
echo =======================================================
echo.
pause
GOTO menu

:end
exit

