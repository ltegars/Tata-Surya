import subprocess
import json

cmd = ['powershell', '-NoProfile', '-Command', "Get-CimInstance Win32_Process -Filter \"Name = 'chrome.exe'\" | Select-Object -ExpandProperty CommandLine"]
res = subprocess.run(cmd, capture_output=True, text=True)
import re
ports = set(re.findall(r'--remote-debugging-port=(\d+)', res.stdout))
print("REMOTE_DEBUG_PORTS:", list(ports))
