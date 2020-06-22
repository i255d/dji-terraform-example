###  Add first set-location path for refference.  ###

###   Maybe go back to RunMeOnce.ps1              ####
###   Because you need the configuration files    ####

$env:TF_VAR_First_Set_Location = 'C:\vsts\IA\danspersonalportal\infrastructure-as-code\execution\01start\tf'
Set-Location -Path $env:TF_VAR_First_Set_Location
try {
    . ..\source\workstationcfg.ps1
} catch {
    Write-Error -Message "The command prompt is not at `"..\..\..\execution\01start\tf`""
}

$Feature = 'storage_account_state'
if ( Test-Path -Path '..\source\tfconfig.ps1' ) {
    . ..\source\tfconfig.ps1 -CN $Companyname -TF $TFVersion -Ftr $Feature -Rsn $ResourceName
} else {
    throw "Test-Path FAILED - '..\source\tfconfig.ps1'"
}

#.  ..\..\..\environment\prod\Get-EnvironmentVariables.ps1
$tfPath = $StartPath + '/tfs'
$networkObj = Import-Csv -Path ..\source\BaseInfrastructure.csv
$networkObj.environment
$InvSASParams = @{
    CurrentRepoPath = $CurrentRepoPath
    PrivateConfigurationPath = $tfPath
    Environment = $StartEnvironment 
    Azurermversion = '2.15' 
    TerraformVersionPath = $TerraformVersionPath
    Destroy = $false
}
../../../execution/storage_account_state/scripts/Invoke-StorageAccountState.ps1 @InvSASParams









