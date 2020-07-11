#  Note: This creates a EC2-Classic, not a EC2-VCP
Install-Module AWSPowerShell 
Set-AWSCredential -ProfileName danspersonalaws
$myIp = ((curl http://icanhazip.com).Content).trim() + '/32'
$Region = 'us-west-2'
$SecurityGroupName = 'exclassonedji-sg'
$SGDescription = 'Exercise One Network Security Group Classic'
$amiPath = 'ami-windows-latest'
$amiImageName = 'Windows_Server-2019-English-Full-Base'
$InstanceType = 't2.micro'
$KeyPairName = 'awsc-dji-win2019' 
$DownloadPath = 'C:\Users\daniv\Downloads\AWS\Key\' + $KeyPairName + '.pem'

$KeyPairObj = New-EC2KeyPair -KeyName $KeyPairName
#$KeyPairObj | Format-List KeyName, KeyFingerprint, KeyMaterial
$KeyPairObj.KeyMaterial | Out-File -Encoding ascii -FilePath $DownloadPath

$groupid = New-EC2SecurityGroup -GroupName $SecurityGroupName -GroupDescription $SGDescription
$cidrBlocks = New-Object 'collections.generic.list[string]'
$cidrBlocks.add($myIp)
$ipPermissions = New-Object Amazon.EC2.Model.IpPermission
$ipPermissions.IpProtocol = "tcp"
$ipPermissions.FromPort = 3389
$ipPermissions.ToPort = 3389
$ipPermissions.IpRanges = $cidrBlocks
$ipPermissions2 = New-Object Amazon.EC2.Model.IpPermission
$ipPermissions2.IpProtocol = "tcp"
$ipPermissions2.FromPort = 80
$ipPermissions2.ToPort = 80
$ipPermissions2.IpRanges = '0.0.0.0/0'
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions $ipPermissions
Grant-EC2SecurityGroupIngress -GroupName $SecurityGroupName -IpPermissions $ipPermissions2
(Get-EC2SecurityGroup -GroupIds $groupid).IpPermissions

$AvailabiltyZone = Get-EC2AvailabilityZone
$AzList = $AvailabiltyZone.Where({ $_.GroupName -eq $Region }) | Select ZoneName
$Az = $AzList.ZoneName[-2]

$ami = Get-SSMLatestEC2Image -Path $amiPath -ImageName $amiImageName -Region $Region 

$params = @{
      ImageId = $ami
      MinCount = 1
      MaxCount = 1
      KeyName = $KeyPairName
      InstanceType = $InstanceType
      SecurityGroup = $SecurityGroupName
}
$VMObj = New-EC2Instance @params
$reservation = New-Object 'collections.generic.list[string]'
$reservation.add($VMObj.ReservationId)
$filter_reservation = New-Object Amazon.EC2.Model.Filter -Property @{Name = "reservation-id"; Values = $reservation}
(Get-EC2Instance -Filter $filter_reservation).Instances

$EBSDisk = New-EC2Volume -AvailabilityZone $Az -Encrypted $true -Size 1 -VolumeType gp2
Start-Sleep -Seconds 10
Add-EC2Volume -InstanceId $VMObj.Instances.InstanceId -VolumeId $EBSDisk.VolumeId -Device 'xvdf'
#  Windows Devices: xvdf through xvdp

##  Disk - Init - Partition - Volume - Format
$diskObj = Get-Disk | Where-Object { $_.OperationalStatus -eq 'Offline' }
Initialize-Disk -Number $diskObj.Number
New-Partition -DiskNumber $diskObj.Number -AssignDriveLetter –UseMaximumSize -GptType 'ebd0a0a2-b9e5-4433-87c0-68b6b72699c7'
Format-Volume -DriveLetter D -FileSystem NTFS -NewFileSystemLabel "data_drive"
New-Item -Path D:\ -Name data_drive -ItemType Directory 
