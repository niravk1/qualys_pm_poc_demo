$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('https://www.slimjet.com/chrome/download-chrome.php?file=files%2F103.0.5060.53%2FChromeStandaloneSetup64.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor = "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

$LocalTempDir = $env:TEMP; $FirefoxInstaller = "FirefoxInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('https://download-installer.cdn.mozilla.net/pub/firefox/releases/101.0.1/win64/en-US/Firefox%20Setup%20101.0.1.exe', "$LocalTempDir\$FirefoxInstaller"); & "$LocalTempDir\$FirefoxInstaller" /silent /install; $Process2Monitor = "FirefoxInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$FirefoxInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)