[CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$CNName,
        [ValidateNotNullOrEmpty()]
        [string]$SPDisplayName
    )

$CNName = 'danspersonalportalroot'
$SPDisplayName = 'danspersonalportal'
$cnstr = 'CN=' + $CNName 
$keyspec = 'Exchange'
$StoreLocation = 'CurrentUser'

(Get-AzSubscription -SubscriptionName "Contoso Default").TenantId

if ( $PSVersionTable.PSEdition -eq 'Desktop' ) {
    $cert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" `
    -Subject $cnstr `
    -KeySpec KeyExchange
    $keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())

    $sp = New-AzADServicePrincipal -DisplayName $SPDisplayName `
    -CertValue $keyValue `
    -EndDate $cert.NotAfter `
    -StartDate $cert.NotBefore
    Start-Sleep 20
    New-AzRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $sp.ApplicationId

} elseif ( $PSVersionTable.PSEdition -eq 'Core' ) {
    # Only run if you could not use New-SelfSignedCertificate
    Import-Module -Name C:\vsts\IA\dji-terraform-example\New-SelfSignedCertificateEx.ps1

    $SSCertParam = @{
        StoreLocation = $StoreLocation
        Subject = $cnstr
        KeySpec = $keyspec
        FriendlyName = $SPDisplayName
    }

    New-SelfSignedCertificateEx @SSCertParam

    $cert = Get-ChildItem -path Cert:\CurrentUser\my | Where-Object {$PSitem.Subject -eq $cnstr }

}


$TenantId = (Get-AzSubscription -SubscriptionName "Contoso Default").TenantId
$ApplicationId = (Get-AzADApplication -DisplayNameStartWith exampleapp).ApplicationId

 $Thumbprint = (Get-ChildItem cert:\CurrentUser\My\ | Where-Object {$_.Subject -eq "CN=exampleappScriptCert" }).Thumbprint
 Connect-AzAccount -ServicePrincipal `
  -CertificateThumbprint $Thumbprint `
  -ApplicationId $ApplicationId `
  -TenantId $TenantId

######################################################################################
