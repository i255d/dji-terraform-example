
C:\01servers\danspersonalportal\cert\Connect-DansPP.ps1

New-AzResourceGroup 
Get-LPAccounts | Where-Object { $_.Username -match "hotmail" } | Where { $_.name -match "" }
