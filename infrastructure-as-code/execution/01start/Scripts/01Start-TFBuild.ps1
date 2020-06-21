##  Terraform requires AzureCli, Install with Invoke-WebRequest on next line.
#Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
###  Virtual_Network must be built one at at time after State being built one at at time.
###  Type TFC on command prompt to see help file. 

$SubscriptionName = 'DansPersonalPortal'
$VerbosePreference = 'continue'

$Context = Get-AzContext
if ( -not ($Context.Subscription.Name -eq $SubscriptionName) ) {
    C:\01servers\danspersonalportal\cert\Connect-DansPP.ps1
} else {
    Write-Verbose -Message "Context -eq $SubscriptionName"
}

$CompanyName = 'danspersonalportal'
$TFVersion = '1226'
Write-Verbose -Message $TFVersion
$ParamsList = @()
$StartTFPath = 'C:/vsts/IA/' + $CompanyName + '/infrastructure-as-code/execution/01start/tf'
if ( Test-Path -Path $StartTFPath ) {
    Set-Location -Path $StartTFPath
} else {
    Write-Verbose -Message "Unable to fine `$StartTFPath"
}

  # $RGParams = @{
  #   Feature             = 'resource_group'
  #   #ResourceName        = 'prod_alpha_eus_rg'

  #   TerraformInput      = 1,2,3
  # }
  # $ParamsList += $RGParams










foreach ( $Params in $ParamsList ) {
    ../scripts/Invoke-TFConfiguration.ps1 @Params
  }
  