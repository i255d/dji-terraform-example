    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [String] $ApplicationDisplayName,
    
        [ValidateNotNullOrEmpty()]
        [String] $SubscriptionId,
    
        [ValidateNotNullOrEmpty()]
        [String] $CertPath,
    
        [ValidateNotNullOrEmpty()]
        [String] $CertPlainPassword
    )
   
    Connect-AzAccount
    Import-Module Az.Resources
    Set-AzContext -Subscription $SubscriptionId
    
    $CertPassword = ConvertTo-SecureString $CertPlainPassword -AsPlainText -Force
   
    $PFXCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @($CertPath, $CertPassword)
    $KeyValue = [System.Convert]::ToBase64String($PFXCert.GetRawCertData())
   
    $ServicePrincipal = New-AzADServicePrincipal -DisplayName $ApplicationDisplayName
    New-AzADSpCredential -ObjectId $ServicePrincipal.Id -CertValue $KeyValue -StartDate $PFXCert.NotBefore -EndDate $PFXCert.NotAfter
    Get-AzADServicePrincipal -ObjectId $ServicePrincipal.Id 
   
    $NewRole = $null
    $Retries = 0;
    While ($NewRole -eq $null -and $Retries -le 6)
    {
       # Sleep here for a few seconds to allow the service principal application to become active (should only take a couple of seconds normally)
       Sleep 15
       New-AzRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $ServicePrincipal.ApplicationId | Write-Verbose -ErrorAction SilentlyContinue
       $NewRole = Get-AzRoleAssignment -ObjectId $ServicePrincipal.Id -ErrorAction SilentlyContinue
       $Retries++;
    }
    
    $NewRole