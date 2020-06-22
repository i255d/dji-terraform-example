try {
    . ..\source\workstationcfg.ps1
} catch {
    Write-Error -Message "The command prompt is not at `"..\..\..\execution\01start\tf`""
}

$Feature           = 'virtual_network'
$ResourceName      = 'prod_virtual_network'
$Context = Get-AzContext
if ( -not ($Context.Subscription.Name -eq $SubscriptionName) ) {
    C:\01servers\danspersonalportal\cert\Connect-DansPP.ps1
} else {
    Write-Verbose -Message "Context -eq $SubscriptionName"
}

$StartTFPath = 'C:/vsts/IA/' + $CompanyName + '/infrastructure-as-code/execution/01start/tf'
if ( Test-Path -Path $StartTFPath ) {
    Set-Location -Path $StartTFPath
} else {
    Write-Verbose -Message "Unable to fine `$StartTFPath"
}
. ..\source\tfconfig.ps1 -CN $Companyname -TF $TFVersion -Ftr $Feature

if ( $Feature -eq "virtual_network") {
    $envSplit = $ResourceName.Split("_")[0]
    $vNetworkPath = '..\..\..\environment\' + $envSplit + '\Get-EnvironmentVariables.ps1'
    if ( Test-Path -Path $vNetworkPath ) {
        #Invoke-Expression -Command $vNetworkPath
        Invoke-Command -ScriptBlock { . $vNetworkPath }
        $BackendKey = $env:TF_VAR_virtual_network_resource_group_name + '/' + $env:TF_VAR_virtual_network_name + '.tfstate'
        Write-Verbose -Message "Virtual_Network BackendKey: $BackendKey"
    } else {
        throw $_
    }
}



$ENV:TF_VAR_key =  $env:TF_VAR_location  + '/' + $env:TF_VAR_environment + '/' + $BackendKey

$ENV:TF_CLI_ARGS_init = "-backend-config=container_name=$ENV:TF_VAR_container_name -backend-config=key=$ENV:TF_VAR_key -backend-config=resource_group_name=$ENV:TF_VAR_tbe_resource_group_name -backend-config=storage_account_name=$ENV:TF_VAR_storage_account_state_name -plugin-dir=$env:TF_VAR_plugins -reconfigure"
Write-Verbose -Message "Aruguments for TF init: $ENV:TF_CLI_ARGS_init"
$ENV:TF_CLI_ARGS_plan       =    "-out=`"$($env:TF_VAR_plan + 'tfplan')`""
Write-Verbose -Message "Aruguments for TF plan: $ENV:TF_CLI_ARGS_plan "
$ENV:TF_CLI_ARGS_apply      =    "-auto-approve `"$($env:TF_VAR_plan + 'tfplan')`""
Write-Verbose -Message "Aruguments for TF apply: $ENV:TF_CLI_ARGS_apply"
$ENV:TF_CLI_ARGS_destroy    =    '-auto-approve'
Write-Verbose -Message "Aruguments for TF destroy: $ENV:TF_CLI_ARGS_destroy "

Get-ChildItem -Filter "*.tf" | Remove-Item
Write-Verbose -Message "The running Feature is $Feature."
$Freaturetfdir = '../../' + $Feature + '/tf'
if ( -not (Test-Path -Path $Freaturetfdir) ) {
    throw "Line208 in code, Path [$Freaturetfdir] is missing."
}
Write-Verbose -Message "Path to Feature Directory: `$Freaturetfdir = $Freaturetfdir"
$modList = Get-ChildItem -Path $Freaturetfdir -Filter '*.tf' -File 
Write-Verbose -Message "Number of files to copyed from $Freaturetfdir = $($modList.count)"
$modList | Copy-Item -Force
Copy-Item -Path $('../../../provisioning/01version/' + $Azurermversion.replace(".","") + '.tf') -Force

. ../scripts/tfc.ps1

#   $TerraformInput = 1,2,3,5
tfc -Selection $TerraformInput -TerraformVersionPath $env:TF_VAR_terraformversionpath