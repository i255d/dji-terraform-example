    [cmdletbinding()]
param (
    [ValidateNotNullOrEmpty()]
    [Alias("CN")] 
    [string]$CompanyName,
    [ValidateNotNullOrEmpty()]
    [Alias("TFV")] 
    [string]$TFVersion,
    [ValidateNotNullOrEmpty()]
    [Alias("Ftr")] 
    [string]$Feature,
    [ValidateNotNullOrEmpty()]
    [Alias("Rsn")]
    $ResourceName
)
#### Consider adding date to name of logging directory and aging out older logs.
    $VerbosePreference = 'continue'
    $env:TF_IN_AUTOMATION = 1
    #$env:TF_LOG = 'TRACE'
    $env:TF_INPUT=0
    $ENV:TF_VAR_ARM_SKIP_PROVIDER_REGISTRATION = $true
## TESTING for Azure CLI ##
$azVersion = $(az --version | Where-Object {$_ -match "azure-cli" })
if ( -not $azVersion ) {
    Write-Warning "Missing Azure CLI v2, required for use of Terraform."
    throw 
}
$envSplit = $ResourceName.Split("_")[0]
$vNetworkPath = '..\..\..\environment\' + $envSplit + '\Get-EnvironmentVariables.ps1'
Write-Verbose -Message "`$vNetworkPath : $vNetworkPath"
[string]$StartPath = 'C:/01servers' + '/' + $CompanyName
Write-Verbose -Message "`$StartPath : $StartPath"
[string]$CurrentRepoPath = 'C:/vsts/IA' + '/' + $CompanyName
Write-Verbose -Message "`$CurrentRepoPath : $CurrentRepoPath"
[string]$TerraformVersionPath = 'C:/01servers/tf/version' + $TFVersion + '/'
Write-Verbose -Message "`$TerraformVersionPath : $TerraformVersionPath"
[string]$PrivateConfigurationPath = 'C:/01servers/' + $CompanyName + '/tfs'
 
$env:TF_VAR_terraformversionpath = $TerraformVersionPath

if ( $env:Path.Split(";") -notcontains $TerraformVersionPath ) {
    $env:Path += ';' + $TerraformVersionPath
    Write-Verbose -Message "Terraform Version: $( & terraform.exe --version )"
}else {
    Write-Verbose -Message "`$env:Path contains $TerraformVersionPath"
    Write-Verbose -Message "Terraform Version: $( & terraform.exe --version )"
}

###  https://www.terraform.io/docs/commands/environment-variables.html
$env:TF_DATA_DIR = $PrivateConfigurationPath + '/state'
if ( -not (Test-Path -Path $env:TF_DATA_DIR -ErrorAction Stop) ) {
    mkdir $env:TF_DATA_DIR 
}
########################
$env:TF_VAR_plugins = $PrivateConfigurationPath + '/plugins'
if ( -not (Test-Path -Path $env:TF_VAR_plugins) ) {
    mkdir $env:TF_VAR_plugins
    Write-Verbose -Message "Created directory: $env:TF_VAR_plugins"
} 
########################
$testConfig = $PrivateConfigurationPath + '/config'
### The TF_CLI_CONFIG_FILE can be used for the $ENV:TF_CLI_ARGS_ values.  
$env:TF_CLI_CONFIG_FILE = $PrivateConfigurationPath + '/config/terraform.rc'
if ( -not (Test-Path -Path $testConfig) ) {
    mkdir $testConfig
    Write-Verbose -Message "Created directory: $testConfig"
    if ( -not (Test-Path -Path $env:TF_CLI_CONFIG_FILE ) ) {
        New-Item -Path $env:TF_CLI_CONFIG_FILE -ItemType File
    }
}
$LOG_PATH = $PrivateConfigurationPath + '/log'
if ( -not (Test-Path -Path $LOG_PATH ) ) {
    mkdir $LOG_PATH
}
$env:TF_LOG_PATH = $LOG_PATH + '/terraform.log'
if ( -not (Test-Path -Path $env:TF_LOG_PATH) ) {
    New-Item -Path $env:TF_LOG_PATH -ItemType File -Name 'terraform.log'
}

$env:TF_VAR_plan = $PrivateConfigurationPath + '/out/'
if ( -not (Test-Path -Path $env:TF_VAR_plan) ) {
    mkdir $env:TF_VAR_plan
}
$env:TF_VAR_plan = $env:TF_VAR_plan.TrimStart("C:")

[string]$fpath = '../../../configuration/' + $Feature + '/'
Write-Verbose -Message "`$fpath : $fpath"
[string]$fpath01 = '../../../configuration/' + $Feature + '/01'
Write-Verbose -Message "`$fpath01 : $fpath01"
[string]$fpath02 = '../../../configuration/' + $Feature + '/02Built'
Write-Verbose -Message "`$fpath02 : $fpath02"
$Freaturetfdir = '../../' + $Feature + '/tf'
if ( -not (Test-Path -Path $Freaturetfdir) ) {
    throw "Line208 in code, Path [$Freaturetfdir] is missing."
}

function Get-ResourceVariables {
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [string]$ResourceName,
        [string]$fpath01 = $fpath01
    )
    $RSConfigFile = $fpath01 + '/' + $ResourceName + '.ps1'
    if ( Test-Path -Path $RSConfigFile ) {
        Invoke-Command -ScriptBlock { . $RSConfigFile }
    } else {
        throw Write-Error -Message "!!! The parameter ResourceName and the file name in resourcename/01/filename, don't match !!!"
    }
}
