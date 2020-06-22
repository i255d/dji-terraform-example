
function global:New-SnapshotState {
        [CmdletBinding()]
        param (
            [string]$tbe_resource_group_name,
            [string]$storage_account_name,
            [string]$container_name,
            [string]$key
        )
        ### Before Apply:
        try {
            $storageAccountObj = Get-AzStorageAccount -ResourceGroupName $tbe_resource_group_name -Name $storage_account_name -ErrorAction Stop
            Write-Verbose -Message "Storage Account Object, name property $($storageAccountObj.StorageAccountName)."
        } catch {
            Write-Warning -Message "Storage Account `"$storage_account_name`" not found."
        }
        try {
            $blob = Get-AzStorageBlob -Context $storageAccountObj.Context -Container $container_name -Blob $key -ErrorAction Stop
            $snap = $blob.ICloudBlob.CreateSnapshot()
            Write-Host "Successful snapshot of:: $($snap.Name)" -ForegroundColor DarkGreen
        } catch {
            Write-Warning -Message "Blob Storage `"$key`", is not found."
        }
}
# $SnapParams = @{
#     tbe_resource_group_name = $ENV:TF_VAR_tbe_resource_group_name
#     storage_account_name = $ENV:TF_VAR_storage_account_state_name
#     container_name = $ENV:TF_VAR_tbe_container_name
#     key = $ENV:TF_VAR_key
# }
# New-SnapshotState @SnapParams
function global:tfc {
    [CmdletBinding()]
    param(
        [string[]]$Selection,
        [string]$TerraformVersionPath
    )

    if ( $Selection ) {
        $inputString = $Selection
    }else{

        $hearString1= @"
        `n            Enter the number or numbers of the terraform commands to run.
        Multiple numbers will run the commands in the order of the input.
        Seperate multiple inputs with comma's like this 1,2,3
"@
        Write-Host $hearString1 -ForegroundColor Cyan
        Write-Host -Object "`n`tEnter `"init`" or `"1`" for terraform init" -ForegroundColor Yellow
        Write-Host -Object "`t`t(This intializes the provider, after first run, it will propt if needed again)" -ForegroundColor DarkGray

        Write-Host -Object "`n`tEnter `"get`" or `"2`" for terraform get" -ForegroundColor Yellow
        Write-Host -Object "`t`t(This is to update any module updates or references)" -ForegroundColor DarkGray

        Write-Host -Object "`n`tEnter `"plan`" or `"3`" for terraform plan" -ForegroundColor Yellow
        Write-Host -Object "`t`t(This will show the plan of what is to be run when applied.  Good for pre testing.)" -ForegroundColor DarkGray

        Write-Host -Object "`n`tEnter `"apply`" or `"4`" for terraform apply" -ForegroundColor Yellow
        Write-Host -Object "`t`t(This will apply the whatever what shown in the plan)" -ForegroundColor DarkGray

        Write-Host -Object "`n`tEnter `"destroy`" or `"5`" for terraform destroy" -ForegroundColor Yellow
        Write-Host -Object "`t`t(This will destroy everything that is current in the state file.)" -ForegroundColor DarkGray
        if (-not $i){
            [string[]]$inputString = 1,2,3
        }
        else {
            [string[]]$inputString = Read-Host -Prompt "Enter Here:"
        }

    }
    if ($inputString -match ","){
        $inputArray = $inputString.Split(",").Trim()
    }else{
        $inputArray = @()
        $inputArray += $inputString
    }

    foreach ( $inP in $inputArray ) {
        switch ( $inP )
        {
            init {
                $tfinit = $TerraformVersionPath + 'terraform.exe init'
                Invoke-Expression $tfinit
            }

            1 {     
                $tfinit = $TerraformVersionPath + 'terraform.exe init'
                Invoke-Expression $tfinit
            }

            get { 
                $tfget = $TerraformVersionPath + 'terraform.exe get'
                Invoke-Expression $tfget
            }

            2 { 
                $tfget = $TerraformVersionPath + 'terraform.exe get'
                Invoke-Expression $tfget
            }

            plan {  
                $tfplan = $TerraformVersionPath + 'terraform.exe plan'
                Invoke-Expression $tfplan
            } 

            3 {  
                $tfplan = $TerraformVersionPath + 'terraform.exe plan'
                Invoke-Expression $tfplan
            } 

            apply { 
                $SnapParams = @{
                    tbe_resource_group_name = $ENV:TF_VAR_tbe_resource_group_name
                    storage_account_name = $ENV:TF_VAR_storage_account_state_name
                    container_name = $ENV:TF_VAR_tbe_container_name
                    key = $ENV:TF_VAR_key
                }
                New-SnapshotState @SnapParams
                $tfapply = $TerraformVersionPath + 'terraform.exe apply'
                Invoke-Expression $tfapply
            }
                
            4 {  
                $SnapParams = @{
                    tbe_resource_group_name = $ENV:TF_VAR_tbe_resource_group_name
                    storage_account_name = $ENV:TF_VAR_storage_account_state_name
                    container_name = $ENV:TF_VAR_tbe_container_name
                    key = $ENV:TF_VAR_key
                }
                New-SnapshotState @SnapParams
                $tfapply = $TerraformVersionPath + 'terraform.exe apply'
                Invoke-Expression $tfapply
            } 

            destroy {  
                $SnapParams = @{
                    tbe_resource_group_name = $ENV:TF_VAR_tbe_resource_group_name
                    storage_account_name = $ENV:TF_VAR_storage_account_state_name
                    container_name = $ENV:TF_VAR_tbe_container_name
                    key = $ENV:TF_VAR_key
                }
                New-SnapshotState @SnapParams
                $tfdestroy = $TerraformVersionPath + 'terraform.exe destroy'
                Invoke-Expression $tfdestroy
            }

            5 {  
                $SnapParams = @{
                    tbe_resource_group_name = $ENV:TF_VAR_tbe_resource_group_name
                    storage_account_name = $ENV:TF_VAR_storage_account_state_name
                    container_name = $ENV:TF_VAR_tbe_container_name
                    key = $ENV:TF_VAR_key
                }
                New-SnapshotState @SnapParams
                $tfdestroy = $TerraformVersionPath + 'terraform.exe destroy'
                Invoke-Expression $tfdestroy
            }

            default { Write-Warning -Message "`"$inP`" is not a proper entry"  }
        }
    }
}

