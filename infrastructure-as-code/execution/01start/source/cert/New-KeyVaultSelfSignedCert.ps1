[CmdletBinding()]
param (
    $IssuerName          = 'self',
    $SecretContentType   = 'application/x-pkcs12',
    $SubjectName,  #CN=azureappgwssl
    $DNSName,  #CompanyName.com
    $ValidityInMonths,  #24
    $VaultName,
    $CertName,  #certnameroot
    $EmailAtBeforeExpiry =  30,
    $KeySize             =  4096
    #The key size in bits. For example: 2048, 3072, or 4096 for RSA
)
$Context = Get-AzContext
if ( -not ($Context.Subscription.Name -eq $SubscriptionName) ) {
    Invoke-Expressions -Command $authPath
} else {
    Write-Verbose -Message "Context -eq $SubscriptionName"
}
#     https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
###   https://docs.microsoft.com/en-us/powershell/module/az.keyvault/new-azkeyvaultcertificatepolicy?view=azps-3.3.0
$CertPolicyParam = @{
     SecretContentType               = $SecretContentType 
     SubjectName                     = $SubjectName 
     IssuerName                      = $IssuerName 
     ValidityInMonths                = $ValidityInMonths 
     ReuseKeyOnRenewal               = $true
     DnsName                         = $DNSName 
     EmailAtNumberOfDaysBeforeExpiry = $EmailAtBeforeExpiry
     KeySize                         = $KeySize
}

$certificatepolicy = New-AzKeyVaultCertificatePolicy @CertPolicyParam

$KeyVaultCertParam = @{
    VaultName         = $VaultName 
    Name              = $CertName 
    CertificatePolicy = $certificatepolicy
}
$KeyVaultCertificateOut = Add-AzKeyVaultCertificate @KeyVaultCertParam
$KeyVaultCertificateOut

Start-Sleep -Seconds 5

$KeyVaultCertificate = Get-AzKeyVaultCertificate -VaultName $VaultName -Name $CertName
$KeyVaultCertificate
Get-AzKeyVaultCertificatePolicy -VaultName $VaultName -Name $CertName
