[CmdletBinding()]
param(
    [string]$CompanyName
)
$CompanyName = 'danspersonalportal'
# $TF_AUTH_VARIABLES = '. C:\01servers\' + $CompanyName + '\cert\Terraform-EnvironmentalAuthVariables.ps1'
# Invoke-Expression -Command $TF_AUTH_VARIABLES
###  Prior to running, fill in ..\source\workstationcfg.ps1 before running this script.
$env:TF_VAR_First_Set_Location = 'C:\vsts\IA\danspersonalportal\infrastructure-as-code\execution\01start\tf'
Set-Location -Path $env:TF_VAR_First_Set_Location
try {
    . ..\source\workstationcfg.ps1
} catch {
    Write-Error -Message "The command prompt is not at `"..\..\..\execution\01start\tf`""
}

# $Feature = 'storage_account_state'
# if ( Test-Path -Path '..\source\tfconfig.ps1' ) {
#     . ..\source\tfconfig.ps1 -CN $Companyname -TF $TFVersion -Ftr $Feature -Rsn $ResourceName
# } else {
#     throw "Test-Path FAILED - '..\source\tfconfig.ps1'"
# }

####   Must verify that storage account name for Terraform remote state is availble for use. ####
####   Storage account names are unique all across azure   ####
##  This creates the configuration files for Resourcegroups, Virtual Networks in Get-EnvironmentVariables.ps1, Subnets, and Public IP
##  Then it creates the Storage Accounts and Containers for State for each environment.  

if ( -not (Test-Path -Path $StartPath) ) {
    mkdir $StartPath
    Write-Verbose -Message "New Directory made: `"$StartPath`""
}
$tfPath = $StartPath + '/tfs'
if ( -not ( Test-Path -Path $tfPath ) ) {
    Microsoft.PowerShell.Archive\Expand-Archive -Path ..\source\tfs.zip -DestinationPath $StartPath
    Write-Verbose -Message "Expand-Archive -Path ..\source\tfs.zip"
}

$configurationPath = '..\..\..\configuration\'
$environmentPath = '..\..\..\environment\'
###   IMPORT CSV File.
$networkObj = Import-Csv -Path ..\source\BaseInfrastructure.csv
foreach ( $feature in $networkObj ) {
        $envFolder = $environmentPath + $feature.environment
        $envFile = $envFolder + '\Get-EnvironmentVariables.ps1'
        if ( -not ( Test-Path -Path $envFolder ) ) {
            New-Item -Path $envFolder -ItemType Directory
        }
        if ( -not ( Test-Path -Path $envFile ) ) {
            New-Item -Path $envFile -ItemType File
        }
$tags = @"
    `$env:TF_VAR_environment                        =       `'$($feature.environment)`'
    `$env:TF_VAR_location                           =       `'$($feature.location)`'
    `$env:TF_VAR_cost_center                        =       `'$($feature.cost_center)`'
"@
    $rgDirectory = $configurationPath + 'resource_group\02built'
    if ( -not (Test-Path -Path $rgDirectory) ) {
        mkdir $rgDirectory
    }

    $tbe_resource_group_name = $feature.environment + '_' + $feature.tbe_resource_group_name

    $diagnostics_resource_group_name = $feature.environment + '_' + $feature.diagnostics_resource_group_name
    $diagnostics_storage_account_name = $feature.environment + $feature.diagnostics_storage_account_name
    $drgFile = $rgDirectory + '\' + $diagnostics_resource_group_name + '.ps1'

$drgValue = @"
    `$ENV:TF_VAR_resource_group_name                =       `'$diagnostics_resource_group_name`'
"@
    if ( -not ( Test-Path -Path $drgFile ) ) {
        New-Item -Path $drgFile -ItemType File -value  $($drgValue + "`n" + $tags)
    }
    $network_resource_group_name = $feature.environment + '_' + $feature.network_resource_group_name
    $nrgFile = $rgDirectory + '\' + $network_resource_group_name+ '.ps1'
$nrgValue = @"
    `$ENV:TF_VAR_resource_group_name                =       `'$network_resource_group_name`'
"@
    if ( -not ( Test-Path -Path $nrgFile ) ) {   
        New-Item -Path $nrgFile -ItemType File -value  $($nrgValue + "`n" + $tags)
    }

    $storage_account_state_name = $feature.environment + '_' + $feature.storage_account_state_name
    $StateSAPath = $configurationPath + 'storage_account_state\01'
    $StateSAFile = $StateSAPath + '\' + $storage_account_state_name + '.ps1'
$stateValue = @"
###  The variable for storage_account_state_name is included for naming of State file for recreate state.
    `$ENV:TF_VAR_storage_account_state_name         =       `'$storage_account_state_name`'
"@
    if (-not (Test-Path -Path $StateSAPath ) ) {
        mkdir $StateSAPath 
        Write-Verbose -Message "Created Directory: $StateSAPath"
    }
    if (-not (Test-Path -Path $StateSAFile ) ) {
        New-Item -Path $StateSAFile -ItemType File -Value $($stateValue + "`n" + $tags)
    }

    $virtual_network_name = $feature.environment + '_' + $feature.virtual_network_name
    $network_security_group_name = $feature.environment + '_' + $feature.network_security_group_name
    #$dnsSplit = $feature.virtual_network_dns_servers.Split(",").trim().replace("`"","")
$envVariables = @"
    `$ENV:TF_VAR_virtual_network_resource_group_name=       `'$network_resource_group_name`'
    `$env:TF_VAR_virtual_network_name               =       `'$virtual_network_name`'
    `$env:TF_VAR_virtual_network_address_space      =       `'[`"$($feature.virtual_network_address_space)`"]`'
    `$env:TF_VAR_virtual_network_dns_servers        =       `'$($feature.virtual_network_dns_servers)`'
    `$env:TF_VAR_network_security_group_name        =       `'$network_security_group_name`'
    `$ENV:TF_VAR_storage_account_state_name         =       `'$storage_account_state_name`'
    `$ENV:TF_VAR_tbe_resource_group_name            =       `'$tbe_resource_group_name`'
    `$ENV:TF_VAR_tbe_container_name                 =       `'terraformstate`'
    `$ENV:TF_VAR_account_tier                       =       `'Standard`'
    `$ENV:TF_VAR_account_replication_type           =       `'LRS`'
    `$ENV:TF_VAR_account_kind                       =       `'BlobStorage`'
    `$ENV:TF_VAR_container_access_type              =       `'blob`'
    `$ENV:TF_VAR_diagnostics_resource_group_name    =       `'$diagnostics_resource_group_name`'
    `$env:TF_VAR_diag_storage_account_name          =       `'$diagnostics_storage_account_name`'
    `$IsNetworkBuilt                                =       `$false
"@
    Add-Content -Path $envFile -Value $($envVariables + "`n" + $tags)

    $SubnetPath = $configurationPath + 'subnet\02built'
    function Set-SubnetConfig {
        param (
            $SubnetName,
            $IpaddressPrefix,
            #$NetworkRGName,
            $ServiceEndpoint,
            $Env,
            $EnvFile,
            $Tags,
            $SubnetPath
        )
    . ..\source\service_endpoint_reference.ps1
    $sNumb = $ServiceEndpoint.split(",").trim()
    $sCount = $sNumb.count
    $i=1
    $seStr = '''['
    foreach ( $se in $sNumb ) {
        if ( $i -ne $sCount ) {
            $seStr =  $seStr + '"' + $global:servcie_endpoint_reference[$se] + '", '
        }else {
            $seStr =  $seStr.TrimEnd(",") +  '"' + $global:servcie_endpoint_reference[$se]  + "`"]`'"
        }
        ++$i
    }

$subnetVariables = @"
    `$env:TF_VAR_subnet_name                        =       `'$SubnetName`'
    `$env:TF_VAR_address_prefixes                   =       `'$IpaddressPrefix`'
    `$ENV:TF_VAR_service_endpoints                  =       $seStr 
"@

    if ( -not ( Test-Path -Path $SubnetPath ) ) {
        mkdir $SubnetPath 
        Write-Verbose -Message "Created Directory: $SubnetPath"
    }
    $SubnetFile = $SubnetPath + '\' + $Env + '_' + $SubnetName + '.ps1'
    if ( -not ( Test-Path -Path $SubnetFile ) ) {
        New-Item -Path $SubnetFile -ItemType File -Value $($subnetVariables + "`n" + $Tags)
    }
}

    $SubConfigParam1 = @{
        SubnetName = $feature.subnet_name1
        IpaddressPrefix = $feature.subnet1_ip_address
        ServiceEndpoint = $feature.service_endpoints1
        Env = $feature.environment
        EnvFile = $envFile
        Tags = $tags
        SubnetPath = $SubnetPath
    }
    Set-SubnetConfig @SubConfigParam1

    $SubConfigParam2 = @{
        SubnetName = $feature.subnet_name2
        IpaddressPrefix = $feature.subnet2_ip_address
        ServiceEndpoint = $feature.service_endpoints2
        Env = $feature.environment
        EnvFile = $envFile
        Tags = $tags
        SubnetPath = $SubnetPath
    }
    Set-SubnetConfig @SubConfigParam2

    $SubConfigParam3 = @{
        SubnetName = $feature.subnet_name3
        IpaddressPrefix = $feature.subnet3_ip_address
        ServiceEndpoint = $feature.service_endpoints3
        Env = $feature.environment
        EnvFile = $envFile
        Tags = $tags
        SubnetPath = $SubnetPath
    }
    Set-SubnetConfig @SubConfigParam3

    $SubConfigParam4 = @{
        SubnetName = $feature.subnet_name4
        IpaddressPrefix = $feature.subnet4_ip_address
        ServiceEndpoint = $feature.service_endpoints4
        Env = $feature.environment
        EnvFile = $envFile
        Tags = $tags
        SubnetPath = $SubnetPath
    }
    Set-SubnetConfig @SubConfigParam4

    $SubConfigParam5 = @{
        SubnetName = $feature.subnet_name5
        IpaddressPrefix = $feature.subnet5_ip_address
        ServiceEndpoint = $feature.service_endpoints5
        Env = $feature.environment
        EnvFile = $envFile
        Tags = $tags
        SubnetPath = $SubnetPath
    }
    Set-SubnetConfig @SubConfigParam5

    $pipPath = $configurationPath + 'public_ip\02built'
    $pip_name = $feature.environment + '_' + $feature.public_ip_name 
    $pipFile = $pipPath + '\' + $pip_name + '.ps1'
    
$pipVariables = @"
    `$env:TF_VAR_public_ip_name                     =       `'$pip_name`'
    `$env:TF_VAR_resource_group_name                =       `'$network_resource_group_name`'
    `$env:TF_VAR_pip_allocation_method              =       `'$($feature.pip_allocation_method)'
"@
    if ( -not ( Test-Path -Path $pipPath ) ) {
        mkdir $pipPath
        Write-Verbose -Message "Created Directory: $pipPath"
    }
    if ( -not ( Test-Path -Path $pipFile ) ) {
        New-Item -Path $pipFile -ItemType File -Value $($pipVariables + "`n" + $Tags)
    }

}


# foreach ( $network in $networkObj ) {
#     $InvSASParams = @{
#         CurrentRepoPath = $CurrentRepoPath
#         PrivateConfigurationPath = $tfPath
#         Environment = $network.Environment 
#         Azurermversion = '2.11' 
#         TerraformVersionPath = $TerraformVersionPath
#         Destroy = $false
#     }
#     ../../../execution/storage_account_state/scripts/Invoke-StorageAccountState.ps1 @InvSASParams
# }
    .  ..\..\..\environment\prod\Get-EnvironmentVariables.ps1
    $networkObj = Import-Csv -Path ..\source\BaseInfrastructure.csv
    $networkObj.environment
    $InvSASParams = @{
        ResourceName = $storage_account_state_name 
        CurrentRepoPath = $CurrentRepoPath
        PrivateConfigurationPath = $tfPath
        Environment = $StartEnvironment 
        Azurermversion = '2.15' 
        TerraformVersionPath = $TerraformVersionPath
        Destroy = $false
    }
    ../../../execution/storage_account_state/scripts/Invoke-StorageAccountState.ps1 @InvSASParams