# Terraform Example

    Answer to resource group questions is answered in two ways starting with -
        First - ..\..\01start\Scripts\New-ResourceGroups.ps1
        Second - ..\..\01start\Scripts\01Start-TFBuild.ps1


The use of Terraform in Azure requires the Terraform executable.
The current version is 12.26, located - "C:\01Server\tf\version1226\terraform.exe"
https://www.terraform.io/downloads.html
To create a separation between the Terraform code and parameter files, from resources 
like the Terraform executable and the AzureRm resource provider, as well as some
changeable reference files pointing to state configurations in Azure and such, I use
this directory path.

C:\01Servers
An example is given here:  https://github.com/i255d/01servers

There is also a need to have a way to keep multiple version of some of these downloads 
because over the long run there are breaking changes that require some of your code to remain
on older version while you start using the latest releases and incrementally convert over your 
previous code.  

