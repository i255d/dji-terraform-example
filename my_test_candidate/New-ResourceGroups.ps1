
##  Create an `n` number of resource groups with the their names formatted as 
##  “my- test-candidate-<location>” where <location> comes from a variable called 
##  `locations` which is a list of strings (e.g. ["eastus", "westus"]).

##  This question doesn't address if each resoucegroup should also be created in the location that is included in the name.
##  It also says 'n' number, but doesn't include multiple in the name, so I am going to assume that there is only one per location.  

$LocObj = Get-AzLocation
$LocObj.Count #40 Total Locations
## Here I use .net regex for the locations that end in 'us' by adding the $.
$usLocationLst = $LocObj | Where-Object { $_.Location -match "us$|us2$" } 
$usLocationLst.count  # 6 US Locations 2 US2 Locations
## I realized after I ran this the first time, that there were US locations with a 2 at the end,
## So I added the | (bar) for or in the reg-ex, and then I did not want to make the same RG again,or have
## errors when it went through the list, so I added a list of the existing resourcegroups to limit the 
## New-AzResouceGroup Cmdlets to only names that did not already exist.  
$ResouceGroupObj = Get-AzResourceGroup
$usLocationLst.ForEach({
    $Location = $_.Location 
    $ResourceGroupName = 'my-test-candidate-' + $Location
    if ( $ResouceGroupObj.ResourceGroupName -notcontains $ResourceGroupName ) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    }
})

#   Get-AzResourceGroup | Remove-AzResourceGroup -Force