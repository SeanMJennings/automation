$paths = 
"${env:programFiles(x86)}\Google\Chrome\Application\", 
"$env:programFiles\BraveSoftware\Brave-Browser\Application",
"${env:programFiles}\TeamViewer",
"$env:programFiles\curl\bin",
"$env:programFiles\Git\bin",
"$env:programFiles\Microsoft VS Code",
"$env:programFiles\Microsoft Visual Studio\2022\Proffesional\Common7\IDE",
"$env:programFiles\Azure Data Studio",
"$env:programFiles\Azure Cosmos DB Emulator"

$paths | % {
	if (-not (($env:path -split ';') -contains $_)) {
		$env:path += ';' + $_
	}
}