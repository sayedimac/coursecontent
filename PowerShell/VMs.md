## Method 1

```PowerShell
$VMResources = Get-AzVM #get all the VMs

$vmdetails = New-Object System.Collections.ArrayList #variable to hold vm details in arraylist

$singleVMDetails = [ordered]@{} #show the list in the order

Write-Host "###########################"
Write-Host "RGName, VMName, Tags" -ForegroundColor Red
Write-Host "###########################" -ForegroundColor White

foreach($VMResource in $VMResources) #loop through each VM
{
$existingTags = (Get-AzResource -ResourceGroupName $VMResource.ResourceGroupName -Name $VMResource.Name).Tags #get tags
$singleVMDetails.'RGName' = $VMResource.ResourceGroupName
$singleVMDetails.'VMName' = $VMResource.Name
$singleVMDetails.'Tags' = $existingTags
$vmdetails.Add((New-object PSObject -Property $singleVMDetails)) | Out-Null
Write-Host $VMResource.ResourceGroupName "," $VMResource.Name "," $existingTags -ForegroundColor White #Display details on screen
}

$vmdetails | Export-Csv "vmdetails.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ',' #Export to CSV
```
## Method 2
```PowerShell

Function Get-VmDetailsByTag {
Param (
[string]$ResourceGroup,
[hashtable]$Tag,
[string]$Subscription,
[string]$TenantID
)

Set-AzContext -Tenant $TenantID -Subscription $Subscription

Get-AzResource -Tag $tag -ResourceType “Microsoft.Compute/virtualMachines”

}
