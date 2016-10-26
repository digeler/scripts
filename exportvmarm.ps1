[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$VmName,
   

   [Parameter(Mandatory=$True,Position=2)]
   [string]$ResourceGroup,
     
   
   [Parameter(Mandatory=$True,Position=2)]
   [string]$workfolder
)

Write-Host "Export vm"


$vm =Get-AzureRmVM -ResourceGroupName $ResourceGroup -Name $VmName
ConvertTo-Json $vm -Depth 100 | Out-File -FilePath $workfolder'\'$VmRG-$Vmname'.json'

$vm.OSProfile = $null
$Vm.StorageProfile.ImageReference = $null
if ($Vm.StorageProfile.OsDisk.Image) {$Vm.StorageProfile.OsDisk.Image = $null}
$Vm.StorageProfile.OsDisk.CreateOption = 'Attach'
for ($s=1;$s -le $Vm.StorageProfile.DataDisks.Count ; $s++ )
{
$Vm.StorageProfile.DataDisks[$s-1].CreateOption = 'Attach'
}

Write-Host "creating the vm"

 New-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -Location $vm.Location -VM $vm

