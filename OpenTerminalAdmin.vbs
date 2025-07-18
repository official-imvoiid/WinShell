Set objShell = CreateObject("Shell.Application")
objShell.ShellExecute "wt.exe", "-d """ & WScript.Arguments(0) & """", "", "runas", 1