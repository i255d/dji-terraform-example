$script_location = 'C:\vsts\IA\' + $companyname + '\infrastructure-as-code\execution\01start\tf'
Set-Location -Path $script_location

$ConfigPath = '..\..\..\configuration'
$EnvironmentPath = '..\..\..\environment'

Get-ChildItem -Path $ConfigPath -Directory | ForEach-Object {
    Get-ChildItem -Path $($_.FullName + '\02built') -Filter *.ps1 | Remove-Item
}

Get-ChildItem -Path $EnvironmentPath -Directory | Remove-Item -Recurse
