function Disable-Startups
{
    [CmdletBinding()]

    Param
    (
        [parameter(DontShow = $true)]
        $32bit = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        [parameter(DontShow = $true)]
        $32bitRunOnce = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
        [parameter(DontShow = $true)]
        $64bit = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run",
        [parameter(DontShow = $true)]
        $64bitRunOnce = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
        [parameter(DontShow = $true)]
        $currentLOU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        [parameter(DontShow = $true)]
        $currentLOURunOnce = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    )

    $disableList = @(
        'NordVPN'
    )

    $regStartList = Get-Item -path $32bit,$32bitRunOnce,$64bit,$64bitRunOnce,$currentLOU,$currentLOURunOnce |
            Where-Object {$_.ValueCount -ne 0} | Select-Object  property,name

    foreach ($regName in $regStartList.name) {
        $regNumber = ($regName).IndexOf("\")
        $regLocation = ($regName).Insert("$regNumber",":")
        if ($regLocation -like "*HKEY_LOCAL_MACHINE*"){
            $regLocation = $regLocation.Replace("HKEY_LOCAL_MACHINE","HKLM")
        }
        if ($regLocation -like "*HKEY_CURRENT_USER*"){
            $regLocation = $regLocation.Replace("HKEY_CURRENT_USER","HKCU")
        }
        foreach($disable in $disableList) {
            if (Get-ItemProperty -Path "$reglocation" -name "$disable" -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path "$reglocation" -Name "$disable"
            }else {write-host $disable "not found in start up apps for" $regName}
        }

    }
}
Clear-Host
Disable-Startups
