$SubscriptionName = 'DansPersonalPortal'
$WorkingPath = 'C:\vsts\IA\dji-terraform-example\infrastructure-as-code\execution\01start\tf'
$VerbosePreference = 'continue'
if ( Test-Path -Path $WorkingPath ) {
    Set-Location -Path $WorkingPath
} else {
    Write-Verbose -Message "Unable to fine `$WorkingPath"
}

$Context = Get-AzContext
if ( -not ($Context.Subscription.Name -eq $SubscriptionName) ) {
    C:\01servers\danspersonalportal\cert\Connect-DansPP.ps1
} else {
    Write-Verbose -Message "Context -eq $SubscriptionName"
}


