$paths = 
"$env:programFiles(x86)\Google\Chrome\Application\", 
"$env:programFiles\TeamViewer",
"$env:programFiles\curl\bin",
"$env:programFiles\Git\bin",
"$env:programFiles\Microsoft VS Code",
"$env:programFiles\Microsoft Visual Studio\2022\Proffesional\Common7\IDE",
"$env:programFiles\Azure Data Studio",
"$env:LOCALAPPDATA\Programs\Rider\bin",
"$env:LOCALAPPDATA\Programs\PyCharm\bin"

$paths | % {
	if (-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}
