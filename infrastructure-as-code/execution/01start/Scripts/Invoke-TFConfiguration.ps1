[CmdletBinding()]
Param (
    [ValidateNotNullOrEmpty()]
    [string]$Feature,
    [ValidateNotNullOrEmpty()]
    [string]$ResourceName,
    [ValidateNotNullOrEmpty()]
    [string]$Azurermversion = '2.15',
    [ValidateNotNullOrEmpty()]
    [string]$Companyname = 'danspersonalportal',
    [ValidateNotNullOrEmpty()]
    [string]$TFVersion = '1226',
    [ValidateNotNullOrEmpty()]
    $TerraformInput
)
$StartTFPath = 'C:/vsts/IA/' + $CompanyName + '/infrastructure-as-code/execution/01start/tf'
if ( Test-Path -Path $StartTFPath ) {
    Set-Location -Path $StartTFPath
} else {
    throw "Test-Path FAILED - `$StartTFPath : $StartTFPath"
}

if ( Test-Path -Path '..\source\tfconfig.ps1' ) {
    . ..\source\tfconfig.ps1 -CN $Companyname -TF $TFVersion -Ftr $Feature -Rsn $ResourceName
} else {
    throw "Test-Path FAILED - '..\source\tfconfig.ps1'"
}

if ( Test-Path -Path $vNetworkPath ) {
    #Invoke-Expression -Command $vNetworkPath
    Invoke-Command -ScriptBlock { . $vNetworkPath }
} else {
    throw "Test-Path FAILED - `$vNetworkPath: $vNetworkPath"
}

if ( Test-Path -Path '../scripts/tfc.ps1' ) {
    . ../scripts/tfc.ps1
} else {
    throw "Test-Path FAILED - '../scripts/tfc.ps1'"
}

if ( $Feature -eq "virtual_network") {
    $BackendKey = $env:TF_VAR_virtual_network_resource_group_name + '/' + $env:TF_VAR_virtual_network_name + '.tfstate'
    Write-Verbose -Message "Virtual_Network BackendKey: $BackendKey"
}

if ( $Feature -eq "subnet" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_subnet_name : $env:TF_VAR_subnet_name"
    $BackendKey = $env:TF_VAR_virtual_network_resource_group_name + '/' + $env:TF_VAR_subnet_name + '.tfstate'
    Write-Verbose -Message "Subnet Backendkey: $BackendKey"
}

if ( $Feature -eq "resource_group" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_resource_group_name : $env:TF_VAR_resource_group_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '.tfstate'
    Write-Verbose -Message "Resource_Group BackendKey: $BackendKey"
}

if ( $Feature -eq "public_ip" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_public_ip_name : $env:TF_VAR_public_ip_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_public_ip_name + '.tfstate'
    Write-Verbose -Message "Public_ip Backendkey: $BackendKey"
}

if ( $Feature -eq "storage_account_container" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_storage_account_name : $env:TF_VAR_storage_account_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_storage_account_name  + '/' + $env:TF_VAR_container_name  + '.tfstate'
    Write-Verbose -Message "Storage_account Container BackendKey: $BackendKey"
}

if ( $Feature -eq "storage_account_share" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_storage_account_name : $env:TF_VAR_storage_account_name - $env:TF_VAR_share_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_storage_account_name  + '/' + $env:TF_VAR_share_name + '.tfstate' 
    Write-Verbose -Message "Storage_account Share BackendKey: $BackendKey"
}

if ( $Feature -eq "availability_set" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_availability_set_name : $env:TF_VAR_availability_set_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_availability_set_name  + '.tfstate'
    Write-Verbose -Message "Availability_set BackendKey: $BackendKey"
}

if ( $Feature -eq "application_gateway" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_application_gateway_name : $env:TF_VAR_application_gateway_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_application_gateway_name  + '.tfstate'
    Write-Verbose -Message "Application_gateway BackendKey: $BackendKey"
}

if ( $Feature -eq "virtual_network_gateway" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_virtual_network_gateway_name : $env:TF_VAR_virtual_network_gateway_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_virtual_network_gateway_name  + '.tfstate'
    Write-Verbose -Message "Application_gateway BackendKey: $BackendKey"
}

if ( $Feature -eq "windows_virtual_machine" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_windows_virtual_machine_name : $env:TF_VAR_windows_virtual_machine_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_windows_virtual_machine_name  + '.tfstate'
    Write-Verbose -Message "Windows_virtual_machine BackendKey: $BackendKey"
}

if ( $Feature -eq "key_vault" ) {
    Get-ResourceVariables -ResourceName $ResourceName
    Write-Verbose -Message "`$env:TF_VAR_key_vault_name : $env:TF_VAR_key_vault_name"
    $BackendKey = $env:TF_VAR_resource_group_name + '/' + $env:TF_VAR_key_vault_name + '.tfstate'
    Write-Verbose -Message "Key_vault Backendkey: $BackendKey"
}

$ENV:TF_VAR_key =  $env:TF_VAR_location  + '/' + $env:TF_VAR_environment + '/' + $BackendKey
$ENV:TF_CLI_ARGS_init =  "-backend-config=container_name=$ENV:TF_VAR_tbe_container_name"
$ENV:TF_CLI_ARGS_init += " -backend-config=key=$ENV:TF_VAR_key"
$ENV:TF_CLI_ARGS_init += " -backend-config=resource_group_name=$ENV:TF_VAR_tbe_resource_group_name"
$ENV:TF_CLI_ARGS_init += " -backend-config=storage_account_name=$ENV:TF_VAR_storage_account_state_name"
$ENV:TF_CLI_ARGS_init += " -plugin-dir=$env:TF_VAR_plugins -reconfigure"
Write-Verbose -Message "Aruguments for TF init: $ENV:TF_CLI_ARGS_init"
$ENV:TF_CLI_ARGS_plan = "-out=`"$($env:TF_VAR_plan + 'tfplan')`""
Write-Verbose -Message "Aruguments for TF plan: $ENV:TF_CLI_ARGS_plan "
$ENV:TF_CLI_ARGS_apply = "-auto-approve `"$($env:TF_VAR_plan + 'tfplan')`""
Write-Verbose -Message "Aruguments for TF apply: $ENV:TF_CLI_ARGS_apply"
# $ENV:TF_CLI_ARGS_destroy = '-auto-approve'
# Write-Verbose -Message "Aruguments for TF destroy: $ENV:TF_CLI_ARGS_destroy"

Get-ChildItem -Filter "*.tf" | Remove-Item
Write-Verbose -Message "The running Feature is $Feature."
Write-Verbose -Message "Path to Feature Directory: `$Freaturetfdir = $Freaturetfdir"
$modList = Get-ChildItem -Path $Freaturetfdir -Filter '*.tf' -File 
Write-Verbose -Message "Number of files to copyed from $Freaturetfdir = $($modList.count)"
$modList | Copy-Item -Force
Copy-Item -Path $('../../../provisioning/01version/' + $Azurermversion.replace(".","") + '.tf') -Force

#. ../scripts/tfc.ps1
#   $TerraformInput = 1,2,3,5
tfc -Selection $TerraformInput -TerraformVersionPath $env:TF_VAR_terraformversionpath
$VerbosePreference = 'silentlycontinue'












# $Companyname = 'profitsword'
# $Feature           = 'virtual_network'
# $ResourceName      = 'prod_virtual_network'
# $TFVersion = '1225'
# $TerraformInput = 1,2,3,4
# $Azurermversion = '2.11'


 ### REthink virtual_network, and when Environment call

# if ( [string]::IsNullOrEmpty( $ResourceName ) ) {
#     if ( $Feature -eq 'virtual_network' ) {
#         $message = "Feature: virtual_network requires either and evironment entry, or all."
#         Write-Warning -Message $message
#         throw $message
#     }
#     $ResourceName = 'New-Configuration'
#     Write-Verbose -Message "No entry in parameter '`$ResourceName', Set to: $ResourceName."
#     if ( $resourcePathList = Get-ChildItem -Path $fpath01 -Filter '*.ps1'  -Recurse -File ) {
#         $resourcePathList = $resourcePathList | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
#         $fString = (Get-Content -Path $resourcePathList.FullName |
#         Where-Object {$error[0] -notmatch "#"} |
#         Where-Object {$_ -match "."} |
#         Select-Object -First 1) 
#         $slString = $fString.Split("=").trim()[1]
#         $cStName = $slString.replace("`"","").replace("`'","")
#         #-match "^`\$.*=(?<resource>.*)" | Out-Null
#         #$cStName = $matches.resource.Trim().replace("`"","").replace("`'","")
#         Write-Verbose -Message "The FEATURE extracted name is $cStName"
#         $bpath = $fpath + '02built'
#         $rPathList = $(Get-ChildItem -Path $bpath -Recurse -File ).FullName
#         $clrPathList = $rPathList | Where-Object { $_ -match $cStName}
#             $clrPathList.Where({$_ -match "`\.bak$"}).foreach({ Remove-Item -Path $_ -Force })
#             $clrPathList.Where({$_ -match "`\.ps1$"}).foreach({ Move-Item -Path $_ -Destination $_.replace("ps1","bak") })
#         $Destination = $bpath + '/' + $cStName + '.ps1'
#         Copy-Item -Path $($resourcePathList.FullName) -Destination $Destination
#     }
# } 
# $fpath02 
# $cStName = $slString.replace("`"","").replace("`'","")
# $bpath = $fpath + '02built'
# $Destination = $bpath + '/' + $cStName + '.ps1'


# if ( $ResourceName -eq 'All'  ) {
#     if ( $Feature -eq 'virtual_network' ) {
#         $resourcePathList = (Get-ChildItem -Path '..\..\..\environment' -Filter 'Get-EnvironmentVariables.ps1' -Recurse).FullName
#         Write-Verbose -Message "This is ALL Switch first Resource is $($resourcePathList[0])"
#     } else {
#         $bpath = $fpath + '02built'
#         $resourcePathList = $(Get-ChildItem -Path $bpath -Filter "*.ps1" -Recurse -File ).FullName
#         Write-Verbose -Message "This is ALL Switch first Resource is $($resourcePathList[0])"
#     }
# } else {
#     if ( $Feature -eq 'virtual_network' ) {
#         $ePath = '..\..\..\environment\' + $ResourceName
#         $resourcePathList = (Get-ChildItem -Path $ePath -Filter 'Get-EnvironmentVariables.ps1' -Recurse).FullName
#         Write-Verbose -Message "This is virtual_network Switch first Resource is $($resourcePathList[0])"
#     } else {
#         $resourcePathList = $(Get-ChildItem -Path $fpath01 -Filter $Destination($ResourceName + '.ps1')  -Recurse -File ).FullName
#         Write-Verbose -Message "This is resource name: $($ResourceName + '.ps1')"
#     }
# }

#$lcount = $resourcePathList.Count
#   $featurePath = $resourcePathList[0]

# foreach ( $featurePath in $resourcePathList ) {
#     if ( Test-Path -Path $featurePath ) {
#         Write-Verbose -Message "FEATURE_Path: $featurePath"
#         Invoke-Expression $featurePath
#     } else {
#         Write-Warning -Message "Unable to verify FEATURE_Path: $featurePath"
#     }
#     if ( $Feature -eq 'virtual_network' ) {
#         Write-Verbose -Message "Feature: Virtual_network, is built from environmental variables only."
#     } else {
#         $envVarPath = '../../../environment/' + $env:TF_VAR_environment + '/Get-EnvironmentVariables.ps1'
#         Write-Verbose -Message "------------------------------------------------------------------"
#         Write-Verbose -Message "$envVarPath"
#         Write-Verbose -Message "------------------------------------------------------------------"
#         if ( Test-Path -Path $envVarPath ) {
#             Write-Verbose -Message "ENV_VAR_Path: $envVarPath"
#             $envVarPathDot = '. ' + $envVarPath
#             Write-Verbose -Message "TEST ENV VARS: $env:TF_VAR_location"
#             Write-Verbose -Message "TEST ENV VARS: $env:TF_VAR_Environment"
#             Write-Verbose -Message "TEST ENV VARS: $env:TF_VAR_Environment"
#             Write-Verbose -Message "TEST ENV VARS: $env:TF_VAR_$env:TF_VAR_resource_group_name"
#             $env:TF_VAR_resource_group_name
#             Invoke-Expression $envVarPathDot
#         }else {
#             Write-Warning -Message "Unable to verify ENV_VAR_Path: $envVarPath"
#         }
#     }   
#     ### These variables are populated from '/environment/$env:TF_VAR_environment/Get-EnvironmentVariables.ps1
#     if ( $ENV:TF_VAR_tbe_resource_group_name ) {
#         Write-Verbose -Message "TF_VAR_tbe_resource_group_name value: $ENV:TF_VAR_tbe_resource_group_name"
#     } else {
#         Write-Error -Message "TF_VAR_tbe_resource_group_name value missing!"
#     }
#     if ( $ENV:TF_VAR_storage_account_state_name ) {
#         Write-Verbose -Message "TF_VAR_storage_account_state_name value: $ENV:TF_VAR_storage_account_state_name"
#     } else {
#         Write-Error -Message "TF_VAR_storage_account_state_name value missing!"
#     }
#     if ( $env:TF_VAR_location ) {
#         Write-Verbose -Message "TF_VAR_location value: $env:TF_VAR_location"
#     } else {
#         Write-Error -Message "TF_VAR_location value missing!"
#     }

    # ###  https://www.terraform.io/docs/commands/environment-variables.html
    # $env:TF_DATA_DIR = $PrivateConfigurationPath + '/state'
    # if ( -not (Test-Path -Path $env:TF_DATA_DIR) ) {
    #     mkdir $env:TF_DATA_DIR 
    # }
    # ########################
    # $env:TF_VAR_plugins = $PrivateConfigurationPath + '/plugins'
    # if ( -not (Test-Path -Path $env:TF_VAR_plugins) ) {
    #     mkdir $env:TF_VAR_plugins
    #     Write-Verbose -Message "Created directory: $env:TF_VAR_plugins"
    # } 
    # ########################
    # $testConfig = $PrivateConfigurationPath + '/config'
    # $env:TF_CLI_CONFIG_FILE = $PrivateConfigurationPath + '/config/terraform.rc'
    # if ( -not (Test-Path -Path $testConfig) ) {
    #     mkdir $testConfig
    #     Write-Verbose -Message "Created directory: $testConfig"
    #     if ( -not (Test-Path -Path $env:TF_CLI_CONFIG_FILE ) ) {
    #         New-Item -Path $env:TF_CLI_CONFIG_FILE -ItemType File
    #     }
    # }

    # $env:TF_LOG_PATH = $PrivateConfigurationPath + '/log'
    # if ( -not (Test-Path -Path $env:TF_LOG_PATH ) ) {
    #     mkdir $env:TF_LOG_PATH
    #     if ( -not (Test-Path -Path $($env:TF_LOG_PATH + '/' + 'terraform.log')) ) {
    #         New-Item -Path $env:TF_LOG_PATH -ItemType File -Name 'terraform.log'
    #     }
    # }
    # $env:TF_LOG_PATH =  $PrivateConfigurationPath + '/log'+ '/terraform.log'
    # $env:TF_VAR_plan = $PrivateConfigurationPath + '/out/'
    # if ( -not (Test-Path -Path $env:TF_VAR_plan) ) {
    #     mkdir $env:TF_VAR_plan
    # }
    # $env:TF_VAR_plan = $env:TF_VAR_plan.TrimStart("C:")

        # ### State File Naming ###
    # if (  $Feature -match "resource_group" ) {
    #     if ( $env:TF_VAR_resource_group_name ) {
    #         $BackendKey = $env:TF_VAR_resource_group_name + '.tfstate'
    #     } elseif ( $ENV:TF_VAR_diagnostics_resource_group_name ) {
    #         $BackendKey = $env:TF_VAR_diagnostics_resource_group_name + '.tfstate'
    #     }elseif ( $ENV:TF_VAR_tbe_resource_group_name ) {
    #         $BackendKey = $env:TF_VAR_tbe_resource_group_name + '.tfstate'
    #     }
    # ### Create rg soloution 
    #     Write-Verbose -Message "Resource_Group BackendKey: $BackendKey"
    # }elseif ( $Feature -match "virtual_network" ) {
    #     $BackendKey = $env:TF_VAR_virtual_network_resource_group_name + '/' + $env:TF_VAR_virtual_network_name + '.tfstate'
    #     Write-Verbose -Message "Virtual_Network BackendKey: $BackendKey"
    # }else {
    #     if ( Test-Path -Path $featurePath ) {
    #         Write-Verbose -Message "`$featurePath: $featurePath"
    #         $firstLine = (Get-Content -Path $featurePath |
    #             Where-Object {$_ -notmatch "#"} |
    #             Where-Object {$_ -match "."} |
    #             Select-Object -First 1) 
    #         $firstLine.TrimStart() -match "^`\$.*=(?<resource>.*)"
    #             $cStName = $matches.resource.Trim().replace("`"","").replace("`'","")
    #         Write-Verbose -Message "The FEATURE extracted name is $cStName"
    #     }
    #     if ( $Feature -eq 'subnet' ) {
    #         $BackendKey = $env:TF_VAR_virtual_network_resource_group_name + '/' + $cStName + '.tfstate'
    #         Write-Verbose -Message "Jointed Resource_Group_Name and the name of the first featured item: $BackendKey"
    #     } else {
    #         $BackendKey = $env:TF_VAR_resource_group_name + '/' + $cStName + '.tfstate'
    #         Write-Verbose -Message "Jointed Resource_Group_Name and the name of the first featured item: $BackendKey"
    #     }
    # }

    # $ENV:TF_VAR_key =  $env:TF_VAR_location  + '/' + $env:TF_VAR_environment + '/' + $BackendKey

    # $ENV:TF_CLI_ARGS_init = "-backend-config=container_name=$ENV:TF_VAR_tbe_container_name -backend-config=key=$ENV:TF_VAR_key -backend-config=resource_group_name=$ENV:TF_VAR_tbe_resource_group_name -backend-config=storage_account_name=$ENV:TF_VAR_storage_account_state_name -plugin-dir=$env:TF_VAR_plugins -reconfigure"
    # Write-Verbose -Message "Aruguments for TF init: $ENV:TF_CLI_ARGS_init"
    # $ENV:TF_CLI_ARGS_plan       =    "-out=`"$($env:TF_VAR_plan + 'tfplan')`""
    # Write-Verbose -Message "Aruguments for TF plan: $ENV:TF_CLI_ARGS_plan "
    # $ENV:TF_CLI_ARGS_apply      =    "-auto-approve `"$($env:TF_VAR_plan + 'tfplan')`""
    # Write-Verbose -Message "Aruguments for TF apply: $ENV:TF_CLI_ARGS_apply"
    # $ENV:TF_CLI_ARGS_destroy    =    '-auto-approve'
    # Write-Verbose -Message "Aruguments for TF destroy: $ENV:TF_CLI_ARGS_destroy "

        # if ( $lcount -gt 1 ) {
    #     tfc -Selection $inputGrThOne -TerraformVersionPath $env:TF_VAR_terraformversionpath
    # } else {
    #     tfc -Selection $inputOne -TerraformVersionPath $env:TF_VAR_terraformversionpath
    # }
#}

#     Get-ChildItem -Filter "*.tf" | Remove-Item
#     Write-Verbose -Message "The running Feature is $Feature."
#     $Freaturetfdir = '../../' + $Feature + '/tf'
#     if ( -not (Test-Path -Path $Freaturetfdir) ) {
#         throw "Line208 in code, Path [$Freaturetfdir] is missing."
#     }
#     Write-Verbose -Message "Path to Feature Directory: `$Freaturetfdir = $Freaturetfdir"
#     $modList = Get-ChildItem -Path $Freaturetfdir -Filter '*.tf' -File 
#     Write-Verbose -Message "Number of files to copyed from $Freaturetfdir = $($modList.count)"
#     $modList | Copy-Item -Force
#     Copy-Item -Path $('../../../provisioning/01version/' + $Azurermversion.replace(".","") + '.tf') -Force

#     . ../scripts/tfc.ps1
#     $env:TF_VAR_terraformversionpath = $TerraformVersionPath
#     if ( $env:Path.Split(";") -notcontains $TerraformVersionPath ) {
#         $env:Path += ';' + $TerraformVersionPath
#         Write-Verbose -Message "Terraform Version: $( & terraform.exe --version )"
#     }else {
#         Write-Verbose -Message "`$env:Path contains $TerraformVersionPath"
#         Write-Verbose -Message "Terraform Version: $( & terraform.exe --version )"
#     }
# #   $TerraformInput = 1,2,3,5
#     tfc -Selection $TerraformInput -TerraformVersionPath $env:TF_VAR_terraformversionpath