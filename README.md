# Terminal Context Menu Manager

**Terminal Context Menu Manager** is a Windows utility that allows you to easily add or remove context menu options for opening **Command Prompt (CMD)**, **PowerShell**, and **Windows Terminal** (both regular and admin modes) in Windows 10 and Windows 11. These options appear when you right-click on folders, drives, or folder backgrounds in File Explorer, providing quick access to your preferred command-line tools.

> **⚠️ WARNING**: This program modifies the Windows Registry, which requires **administrator privileges**. Incorrect registry changes can cause **serious system issues**, potentially leading to catastrophic failures. While this program has been tested on Windows 10 and 11, and includes a registry backup feature, **proceed with caution**. Always ensure you have a backup before making changes.

## Why This Program Was Created

I primarily use **Kali Linux** as my main operating system for its robust terminal capabilities, but I rely on **Windows 10** for office-related tasks and other activities. After a recent update to Windows Terminal via `winget`, I noticed that the convenient "Open Terminal here" context menu option was missing. Despite trying various fixes—such as reinstalling Terminal, deleting configurations, and troubleshooting—the issue persisted. Frustrated, I decided to leverage my scripting skills to create a solution. This program not only restores the Windows Terminal context menu but also extends functionality by adding customizable context menu options for **CMD** and **PowerShell** (both regular and admin modes), providing a comprehensive tool for Windows users.

## Prerequisites

- **Windows 10 or Windows 11**: The program is compatible with both operating systems.
- **Administrator Privileges**: Required to modify the Windows Registry.
- **Command Prompt (CMD) and PowerShell**: These are built into all Windows installations by default.
- **Windows Terminal**:
  - **Windows 11**: Pre-installed by default.
  - **Windows 10**: Must be installed via the Microsoft Store or using `winget` (e.g., `winget install Microsoft.WindowsTerminal`).
- **Icon Files**: The program expects `cmd.ico`, `powershell.ico`, and `terminal.ico` to be present in the same directory as `TerminalContextMenu.bat` for custom context menu icons.
- **VBS Scripts**: The scripts `OpenCmdAdmin.vbs`, `OpenPowerShellAdmin.vbs`, and `OpenTerminalAdmin.vbs` must be in the same directory as the batch file to enable admin-mode context menu options.

## Important Notes

- **Backup**: Before making any registry changes, the program creates a full registry backup in the `RegBackup` folder with a timestamped filename (e.g., `FullRegistry_YYYYMMDD_HHMMSS.reg`). This allows you to restore the registry if needed.
- **File Location**: Place all files (`TerminalContextMenu.bat`, `.vbs` scripts, and `.ico` files) in a fixed directory (e.g., `C:\Users\username\FolderName\WinShell`). **Do not move the files after running the program**, as the registry entries reference the VBS scripts' paths. If you move the files, remove all context menu entries and re-run the program to re-add them.
- **Windows Terminal**: If Windows Terminal is not installed, the program will still attempt to add its context menu entries using a default path or `wt.exe`. Ensure Terminal is installed for these options to work.

## Directory Structure

The program expects the following files and folders in its directory:

```
C:\Users\voiid\github\WinShell
│   cmd.ico                 # Icon for CMD context menu
│   OpenCmdAdmin.vbs       # VBS script for CMD admin mode
│   OpenPowerShellAdmin.vbs # VBS script for PowerShell admin mode
│   OpenTerminalAdmin.vbs  # VBS script for Windows Terminal admin mode
│   powershell.ico         # Icon for PowerShell context menu
│   ReadMe.md              # This documentation file
│   terminal.ico           # Icon for Windows Terminal context menu
│   TerminalContextMenu.bat # Main batch script
│
├───RegBackup
│       FullRegistry_YYYYMMDD_HHMMSS.reg # Registry backups
│
└───Screenshots
        AddAll.png          # Screenshot of "Add All" menu
        AddShellOptions.png # Screenshot of add options menu
        MainScript.png      # Screenshot of main menu
        OpenHere.png        # Screenshot of context menu in File Explorer
        RemoveAll.png       # Screenshot of "Remove All" menu
        RemoveShellOptions.png # Screenshot of remove options menu
```

## Program Details and Functions

`TerminalContextMenu.bat` is a batch script that provides a user-friendly interface to manage context menu entries for CMD, PowerShell, and Windows Terminal. Below are the main features and functions:

### Main Menu Options

1. **Show System Information**:

   - Displays system details, including:
     - Username and computer name.
     - Current and script directories.
     - Paths to `cmd.exe`, `powershell.exe`, and `wt.exe` (if found).
     - Status of icon files (`cmd.ico`, `powershell.ico`, `terminal.ico`).
     - Status of VBS scripts (`OpenCmdAdmin.vbs`, `OpenPowerShellAdmin.vbs`, `OpenTerminalAdmin.vbs`).

2. **Add Terminal Context Menu Options**:

   - Adds context menu entries for:
     - **CMD**: "Open Command Prompt" and "Open Command Prompt (Admin)".
     - **PowerShell**: "Open PowerShell" and "Open PowerShell (Admin)".
     - **Windows Terminal**: "Open Terminal" and "Open Terminal (Admin)".
     - **All**: Adds all of the above.
   - Entries are added for folders, folder backgrounds, and drives in File Explorer.
   - Creates a registry backup before making changes.

3. **Remove Terminal Context Menu Options**:

   - Removes context menu entries for:
     - **CMD**: Removes both regular and admin entries.
     - **PowerShell**: Removes both regular and admin entries.
     - **Windows Terminal**: Removes both regular and admin entries, including legacy `wt` entries.
     - **All**: Removes all of the above.
   - No registry backup is created for removal operations.

4. **Exit**: Closes the program.

### How It Works

- **Registry Modifications**: The script modifies the Windows Registry under `HKEY_CLASSES_ROOT` to add or remove context menu entries for `Directory`, `Directory\Background`, and `Drive`.
- **Admin Privileges**: The script checks for admin rights and prompts for elevation if needed using a temporary VBS script.
- **VBS Scripts**: Admin-mode context menu entries use VBS scripts to launch CMD, PowerShell, or Windows Terminal with elevated privileges and navigate to the selected directory.
- **Icons**: Custom icons (`cmd.ico`, `powershell.ico`, `terminal.ico`) are referenced in the registry for a polished look.
- **Error Handling**: The script checks for the presence of `cmd.exe`, `powershell.exe`, and `wt.exe`, and uses fallback paths if needed.

### Screenshots

- **MainScript.png**: Shows the main menu interface.
- **AddShellOptions.png**: Displays the menu for adding context menu options.
- **AddAll.png**: Shows the process of adding all context menu entries.
- **RemoveShellOptions.png**: Displays the menu for removing context menu options.
- **RemoveAll.png**: Shows the process of removing all context menu entries.
- **OpenHere.png**: Demonstrates the context menu options in File Explorer.

## Usage

1. **Setup**:

   - Download zip or git clone for the required files: `TerminalContextMenu.bat`, `OpenCmdAdmin.vbs`, `OpenPowerShellAdmin.vbs`, `OpenTerminalAdmin.vbs`, `cmd.ico`, `powershell.ico`, and `terminal.ico`.
   - Place all files in a fixed directory (e.g., `C:\Users\voiid\github\WinShell`).
   - Ensure Windows Terminal is installed on Windows 10 (not required for Windows 11).

2. **Running the Program**:

   - Click on `TerminalContextMenu.bat` and prompt **Yes** to **Run as administrator**.
   - Follow the on-screen menu to:
     - View system information.
     - Add or remove context menu entries.
     - Exit the program.

3. **After Adding Entries**:

   - Right-click on a folder, drive, or folder background in File Explorer to see the new "Open Command Prompt", "Open PowerShell", or "Open Terminal" options (regular and admin modes).

4. **If You Move the Files**:

   - Remove all context menu entries using the "Remove All" option.
   - Move the files to the new location.
   - Re-run `TerminalContextMenu.bat` as administrator to re-add the entries with updated paths.

## Troubleshooting

- **Context Menu Not Appearing**: Ensure the script was run as administrator and that the `.ico` and `.vbs` files are in the same directory as `TerminalContextMenu.bat`.
- **Windows Terminal Options Not Working**: Verify that Windows Terminal is installed (Windows 10) and that `wt.exe` is accessible.
- **Registry Issues**: If problems occur, restore the registry using the backup file in the `RegBackup` folder (double-click the `.reg` file and confirm).
- **File Not Found Errors**: Check that all required files (`cmd.ico`, `powershell.ico`, `terminal.ico`, and VBS scripts) are present in the script directory.

## License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
