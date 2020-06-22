##  Terraform requires AzureCli, Install with Invoke-WebRequest on next line.
#Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
###  Virtual_Network must be built one at at time after State being built one at at time.
###  Type TFC on command prompt to see help file. 
try {
    . ..\source\workstationcfg.ps1
} catch {
    Write-Error -Message "The command prompt is not at `"..\..\..\execution\01start\tf`""
}

$ParamsList = @()

  # $RGParams = @{
  #   Feature             = 'resource_group'
  #   #ResourceName        = 'prod_alpha_eus_rg'

  #   TerraformInput      = 1,2,3
  # }
  # $ParamsList += $RGParams










foreach ( $Params in $ParamsList ) {
    ../scripts/Invoke-TFConfiguration.ps1 @Params
  }
  