Set objShell = CreateObject("Shell.Application")
objShell.ShellExecute "powershell.exe", "-NoExit -Command Set-Location -Path '" & WScript.Arguments(0) & "'", "", "runas", 1