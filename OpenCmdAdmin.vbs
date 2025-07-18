Set objShell = CreateObject("Shell.Application")
objShell.ShellExecute "cmd.exe", "/k cd /d """ & WScript.Arguments(0) & """", "", "runas", 1