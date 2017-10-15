Take backup of vhd file using storage explorer.
use below PS cmdlets to start the VM.

Param(  
  [Parameter(Mandatory = $true, 
             HelpMessage="Name of the resource group to which the KeyVault belongs to.  A new resource group with this name will be created if one doesn't exist")]
  [ValidateNotNullOrEmpty()]
  [string]$resourceGroupName,

  [Parameter(Mandatory = $true)]
  [ValidateNotNullOrEmpty()]
  [string]$vmName
  )

$vm = Get-AzureRmVm -ResourceGroupName $resourceGroupName -Name $vmName;
$backupEncryptionSettings = $vm.StorageProfile.OsDisk.EncryptionSettings;
$backupEncryptionSettings;
Stop-AzureRmVM -Name $vmName -ResourceGroupName $resourceGroupName -Force;

## Clear encryption settings from VM model
$vm.StorageProfile.OsDisk.EncryptionSettings.Enabled = $false;
$vm.StorageProfile.OsDisk.EncryptionSettings.DiskEncryptionKey = $null;
$vm.StorageProfile.OsDisk.EncryptionSettings.KeyEncryptionKey = $null;
Update-AzureRmVM -VM $vm -ResourceGroupName $resourceGroupName;

$vm = Get-AzureRmVm -ResourceGroupName $resourceGroupName -Name $vmName;
## Update Encryption settings to add BEK only
$vm.StorageProfile.OsDisk.EncryptionSettings.Enabled = $true;
$vm.StorageProfile.OsDisk.EncryptionSettings.DiskEncryptionKey = $backupEncryptionSettings.DiskEncryptionKey;
Update-AzureRmVM -VM $vm -ResourceGroupName $resourceGroupName;

$vm | Start-AzureRmVm; 

STEP 2. 
2. Using Azure Powershell, remove AzureDiskEncryptionExtension using Remove-AzureRmVmDiskEncryptionExtension cmdlet. This is needed because the VM extension is in inconsistent state than the VM model. 
3. Enable encryption without KEK using credentials. 
4. Enable encryption with KEK using credentials. Do this step only if step4 above is successful. 
