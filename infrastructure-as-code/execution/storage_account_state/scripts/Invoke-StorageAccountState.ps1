[CmdletBinding()]
Param (
    [string]$ResourceName,
    [string]$CurrentRepoPath,
    [string]$PrivateConfigurationPath,
    [string]$Environment,
    [string]$Azurermversion,
    [string]$TerraformVersionPath,
    [switch]$Destroy = $false,
    [switch]$IfFails = $false
)
try {
  . ..\source\workstationcfg.ps1
} catch {
  Write-Error -Message "The command prompt is not at `"..\..\..\execution\01start\tf`""
}
dir env:TF_VAR_*

$ResourceName = 'prod_terrafstate444'
$CurrentRepoPath = $CurrentRepoPath
$PrivateConfigurationPath = $tfPath
$Environment = $StartEnvironment 
$Azurermversion = '2.15' 
$TerraformVersionPath = $TerraformVersionPath
$Destroy = $false
$IfFails = $false

$Feature = 'storage_account_state'
if ( Test-Path -Path '..\source\tfconfig.ps1' ) {
    . ..\source\tfconfig.ps1 -CN $Companyname -TF $TFVersion -Ftr $Feature -Rsn $ResourceName
} else {
    throw "Test-Path FAILED - '..\source\tfconfig.ps1'"
}
# $dotenvpath = '.` ' + $vNetworkPath
# Invoke-Expression -Command $dotenvpath 

Get-ResourceVariables -ResourceName $ResourceName
Write-Verbose -Message "`$env:TF_VAR_storage_account_name : $env:TF_VAR_storage_account_name - $env:TF_VAR_share_name"
$BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_storage_account_name  + '/' + $env:TF_VAR_share_name + '.tfstate' 
Write-Verbose -Message "Storage_account Share BackendKey: $BackendKey"

$sastatePath = '\infrastructure-as-code\execution\storage_account_state\tf'
$CurrentFilePath = $CurrentRepoPath + $sastatePath
Set-Location -Path $CurrentFilePath
$env:TF_DATA_DIR = $PrivateConfigurationPath + '/state'
$env:TF_CLI_CONFIG_FILE = $PrivateConfigurationPath + '/config/terraform.rc'
$env:TF_LOG_PATH =  $PrivateConfigurationPath + '/log'+ '/terraform.log'
$env:TF_IN_AUTOMATION = 1
$env:TF_LOG = 'TRACE'
$env:TF_INPUT = 0
$sourceLocal = '../scripts/local.tf'
$sourceAzureRM = '../scripts/azurerm.tf'
$destLocal = './local.tf'
$localTFState = './terraform.tfstate'
$destAzureRM = './azurerm.tf'
$versionLocal = $Azurermversion.replace(".","") + '.tf'
$provisionVersion = '../../../provisioning/01version/'
$EnvironmentPath = '../../../environment/'
$TF         = $TerraformVersionPath + '/terraform.exe'
$TFinit     = $TF + ' init'
$TFplan     = $TF + ' plan'
$TFapply    = $TF + ' apply'
$TFdestroy  = $TF + ' destroy'
$env:TF_VAR_plugins         =    $PrivateConfigurationPath + '/plugins'
$ENV:TF_CLI_ARGS_init       =    "-plugin-dir=$env:TF_VAR_plugins -reconfigure"
$ENV:TF_CLI_ARGS_plan       =    '-input=false -out=".//tfplan"'
$ENV:TF_CLI_ARGS_apply      =    '-input=false -auto-approve ".//tfplan"'
$ENV:TF_CLI_ARGS_destroy    =    ' -auto-approve'
if ( Test-Path -Path $versionLocal ) {
  Remove-Item -Path $versionLocal -Force -ErrorAction SilentlyContinue
}
Get-ChildItem -Path .\*.tf | Where-Object { $($_.Name).Length -lt 6} | Remove-Item
Copy-Item -Path $($provisionVersion + $Azurermversion.replace(".","") + '.tf') -Force -PassThru
 if ( Test-Path -Path $destAzureRM ) {
   Remove-Item -Path $destAzureRM
 }
 if ( -not ( Test-Path -Path $destLocal ) ) {
   Copy-Item -Path $sourceLocal -Destination $destLocal -PassThru
 }

$envPath = '. ' + $EnvironmentPath  + $Environment + '/Get-EnvironmentVariables.ps1'
if ( Test-Path -Path $($envPath.Substring(2)) ) {
  Invoke-Expression -Command $envPath
  if ( $env:TF_VAR_storage_account_state_name ) {
    Write-Verbose -Message "Showing ENV: Variable: $env:TF_VAR_storage_account_state_name"
  } else {
    Write-Warning -Message "Testing of 'env:TF_VARs not great!"
  }
} else {
  Write-Warning -Message "Test-Path to Get-EnvironmentVariables.ps1"
}
 
if ( $IfFails ) {
  $LocalStatePath = $CurrentFilePath + '\terraform.tfstate'
    if ( Test-Path -Path $LocalStatePath ) {
      Rename-Item -Path $LocalStatePath -NewName '.\temp.tfstate'
    }
  $preBlob = $env:TF_VAR_location + '/' + $env:TF_VAR_environment + '/'
  $blob = $preBlob + $env:TF_VAR_storage_account_state_name + '.tfstate'
  $AzStorage = Get-AzStorageAccount -ResourceGroupName $env:TF_VAR_tbe_resource_group_name -Name $env:TF_VAR_storage_account_state_name
  $AzStorageBlob = Get-AzStorageBlob -Context $AzStorage.Context -Container $env:TF_VAR_container_name
  Get-AzStorageBlobContent -Context $AzStorageBlob.Context -Container $env:TF_VAR_container_name -Blob $blob -Destination $LocalStatePath
  Write-Output "Check terraform.tfstate file for proper content then run without -IfFailed switch."
  return
}
try {
    $env:TF_VAR_environment
    Invoke-Expression $TFinit
    $planOut = Invoke-Expression $TFplan
    $planOut 
} catch {
    throw $_
}

. C:\01servers\danspersonalportal\cert\Terraform-EnvironmentalAuthVariables.ps1



if ( -not $Destroy ) {
  Invoke-Expression $TFapply
  if ( Test-Path -Path $localTFState ) {
    $newName = $($env:TF_VAR_storage_account_state_name + '.tfstate')
    $newNamePath = './'+ $newName
    if ( -not (Test-Path -Path $newNamePath) ) {
      Copy-Item -Path $localTFState -Destination $newNamePath 
    }
  }
} elseif ( $Destroy ) {
  $newName = $($env:TF_VAR_storage_account_state_name + '.tfstate')
  $newNamePath = './'+ $newName
  if ( Test-Path -Path $newNamePath ) {
    Copy-Item -Path $newNamePath -Destination $localTFState -Force -PassThru
  }
  Invoke-Expression $TFdestroy
  Remove-Item -Path $newNamePath
  Remove-Item -Path $localTFState
  return
}

if ( Test-Path -Path $destLocal ) {
  Remove-Item -Path $destLocal
}
if ( -not ( Test-Path -Path $destAzureRM ) ) {
  Copy-Item -Path $sourceAzureRM -Destination $destAzureRM -PassThru
}

if ( Test-Path -Path $($envPath.Substring(2)) ) {
  Invoke-Expression -Command $envPath
  if ( $env:TF_VAR_storage_account_state_name ) {
    Write-Verbose -Message "Showing env:Variable:: $env:TF_VAR_storage_account_state_name"
  } else {
    Write-Warning -Message "Testing of 'env:TF_VARs not great!"
  }
} else {
  Write-Warning -Message "Test-Path to Get-EnvironmentVariables.ps1"
}

$BackendKey = $ENV:TF_VAR_tbe_resource_group_name + '/' + $ENV:TF_VAR_storage_account_state_name + '.tfstate'
$ENV:TF_VAR_key =  $env:TF_VAR_location  + '/' + $env:TF_VAR_environment + '/' + $BackendKey
#$ENV:TF_VAR_key = $env:TF_VAR_location  + '/' + $env:TF_VAR_environment + $BackendKey
$ENV:TF_CLI_ARGS_init = "-backend-config=container_name=$ENV:TF_VAR_tbe_container_name" 
$ENV:TF_CLI_ARGS_init += " -backend-config=key=$ENV:TF_VAR_key"
$ENV:TF_CLI_ARGS_init += " -backend-config=resource_group_name=$ENV:TF_VAR_tbe_resource_group_name"
$ENV:TF_CLI_ARGS_init += " -backend-config=storage_account_name=$ENV:TF_VAR_storage_account_state_name"
$ENV:TF_CLI_ARGS_init += " -plugin-dir=$env:TF_VAR_plugins"
$ENV:TF_CLI_ARGS_init += " -force-copy"
#$ENV:TF_CLI_ARGS_init = $ENV:TF_CLI_ARGS_init + " -reconfigure"
Invoke-Expression $TFinit
Invoke-Expression $TFplan
if ( Test-Path -Path $localTFState ) {
  Remove-Item $localTFState
}
