# Terraform Example
##  The first two steps are fill in the correct paths on the Worksationcft.ps1 file,
##  and build the first storage account for Terraform remote State files.

    Answer to resource group questions is answered in two ways starting with -
        First - ..\..\01start\Scripts\New-ResourceGroups.ps1
        Second - ..\..\01start\Scripts\01Start-TFBuild.ps1

# WorkStation Configuration File:
    infrastructure-as-code\execution\01start\source\workstationcfg.ps1
    // reuse of this code requires refferece to your workstations specific configuration.
    // Set values to variables in .\workstationcfg.ps1 file. 

The use of Terraform in Azure requires the Terraform executable.
The current version is 12.26, located - "C:\01Server\tf\version1226\terraform.exe"
https://www.terraform.io/downloads.html
To create a separation between the Terraform code and parameter files, from resources 
like the Terraform executable and the AzureRm resource provider, as well as some
changeable reference files pointing to state configurations in Azure and such, I use
this directory path.

C:\01Servers
An example is given here:  https://github.com/i255d/01servers
Path must be set in .\workstationcfg.ps1 file.  

There is also a need to have a way to keep multiple version of some of these downloads 
because over the long run there are breaking changes that require some of your code to remain
on older version while you start using the latest releases and incrementally convert over your 
previous code.  

There are files that I filled out default parameters to save from having to put them in each 
call of the scripts as needed.
infrastructure-as-code\execution\01start\Scripts\Invoke-TFConfiguration.ps1
    [string]$Companyname = 'danspersonalportal'
    [string]$Azurermversion = '2.15'
    [string]$TFVersion = '1226'

infrastructure-as-code\execution\01start\Scripts\01Start-TFBuild.ps1
    $SubscriptionName = 'DansPersonalPortal'
    $CompanyName = 'danspersonalportal'
    $TFVersion = '1226'

#  First Create the storage account for Terraform State Files
Before you begin bulding the infrastructure using terraform, a storage account must be created 
for the Terraform State files.  This begins with the scipt:
..\infrastructure-as-code\execution\01start\Scripts\02First-StateStorage.ps1

#  Terraform doesn't support Az Login 
https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_certificate.html#configuring-the-service-principal-in-terraform
https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_certificate.html#configuring-the-service-principal-in-terraform
