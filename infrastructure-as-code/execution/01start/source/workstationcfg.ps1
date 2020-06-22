
$CompanyName = 'dji-terraform-example'
$SubscriptionName = 'DansPersonalPortal'
$StartEnvironment = 'prod'
$TFVersion = '1226'
$Azurermversion = '2.15'
$VerbosePreference = 'continue'

function qtp ($Path) {
    if ( -not (Test-Path -Path $Path) ) {
        Write-Error -Message "`"$Path`" failed test-path"
    }
}

[string]$StartPath = 'C:/01servers' + '/' + $SubscriptionName 
qtp $StartPath
[string]$CurrentRepoPath = 'C:/vsts/IA' + '/' + $CompanyName
qtp $CurrentRepoPath
[string]$TerraformVersionPath = 'C:/01servers/tf/version' + $TFVersion
qtp $TerraformVersionPath
$StartTFPath = 'C:/vsts/IA/' + $CompanyName + '/infrastructure-as-code/execution/01start/tf'
qtp $StartTFPath
$currentPath = (Get-Location).Path
if ( -not ($currentPath -eq $StartTFPath) ) {
    Set-Location -Path $StartTFPath
}

[string] $authPath = ".` " + $StartPath + '/cert/Connect-AzureCertAuthps1.ps1'

$Context = Get-AzContext
if ( -not ($Context.Subscription.Name -eq $SubscriptionName) ) {
    Invoke-Expression -Command $authPath
} else {
    Write-Verbose -Message "Context -eq $SubscriptionName"
}
