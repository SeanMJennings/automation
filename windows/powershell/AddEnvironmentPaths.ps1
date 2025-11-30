$paths = 
"${env:programFiles(x86)}\Google\Chrome\Application\", 
"${env:programFiles}\TeamViewer",
"$env:programFiles\curl\bin",
"$env:programFiles\Git\bin",
"$env:programFiles\Microsoft VS Code",
"$env:programFiles\Microsoft Visual Studio\2022\Proffesional\Common7\IDE",
"$env:programFiles\Azure Data Studio",
"${Env:APPDATA}\Local\Programs\Rider\bin\rider64.exe",
"${Env:APPDATA}\Local\Programs\PyCharm\bin\pycharm64.exe"

$paths | % {
	if (-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}
