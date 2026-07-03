# My Backup Tool

A lightweight Windows utility for creating timestamped backups of files from the context menu or the command line.
This tool copies a file to a .history folder in the same directory and renames the copied file by appending a timestamp.

ex.

`filename_yymmddssssss.ext`

## Installation

1. Place `MyTools` folder in %USERPROFILE%\Documents\.
2. Double-click install_backup_path.cmd to register the `Backup` command in the context menu and add `MyTools` directory path to the user `Path`.

## Usage

### Using the context menu

Right-click a file and select `Backup` from the context menu:

![Context Menu](<backup_screenshot.png>)

### Using the command line

Open a Command Prompt or PowerShell window in the target directory and run:

backup filename

or

backup filename.ext

The backup file will be created in the .history folder in the current directory.

## Uninstallation

1. Double-click uninstall_backup_path.cmd to remove the command from the context menu and remove the `MyTools` folder from your user `Path`.
2. Delete the `MyTools` folder.
