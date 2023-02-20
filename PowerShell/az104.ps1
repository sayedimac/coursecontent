# Install Azure PowerShell Module
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
      'Az modules installed at the same time is not supported.')
} else {
    Install-Module -Name Az -AllowClobber -Scope AllUsers
}

# Install Azure CLI with PowerShell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
remove-item .\AzureCLI.msi

# Login\Connect
Connect-AzAccount 
az login

# Configure AZ CLI
az configure

# saveCreds  variable for PS
$cred = get-credential 

#  CLI
az vm image list-publishers --location southafricanorth
# Get a list of all offers for the MicrosoftWindowsServer publisher
az vm image list-offers --location eastus --publisher MicrosoftWindowsServer
# Get a list of SKUs for the WindowsServer offer
az vm image list-skus --location eastus --publisher MicrosoftWindowsServer --offer WindowsServer
# Get a list of all images available for the 2019-Datacenter SKU
az vm image list --all --location eastus --publisher MicrosoftWindowsServer --offer WindowsServer --sku 2019-Datacenter
# Get the 2019.0.20190603 version of the VM image
az vm image show --location eastus --publisher MicrosoftWindowsServer --offer WindowsServer --sku 2019-Datacenter --version 17763.973.2001110547
# Alternatively, use an URN to get the specified version of the VM image
az vm image show --location eastus --urn MicrosoftWindowsServer:WindowsServer:2019-Datacenter:17763.973.2001110547

# PowerShell
# Get a list of all publishers available in the East US region
Get-AzVMImagePublisher -Location southafricanorth | Format-Table -AutoSize
# Get a list of all offers for the Canonical publisher
Get-AzVMImageOffer -Location eastus -PublisherName Canonical | Format-Table -AutoSize
# Get a list of SKUs for the UbuntuServer offer
Get-AzVMImageSku -Location eastus -PublisherName Canonical -Offer UbuntuServer | Format-Table -AutoSize
# Get a list of all images available for the 19.10-DAILY SKU
Get-AzVMImage -Location eastus -PublisherName Canonical -Offer UbuntuServer -Sku 19.10-DAILY | Format-Table -AutoSize
# Get the 19.10.201906230 version of the VM image
Get-AzVMImage -Location eastus -PublisherName Canonical -Offer UbuntuServer -Sku 19.10-DAILY -Version 19.10.202007100 | Format-Table -AutoSize

#Create a resoruce group
New-AzResourceGroup -Location southafricanorth -Name "az104ps"
az group create --name "az104cli" --location southafricanorth

New-AzVm `
    -ResourceGroupName "az104ps" `
    -Name "az104ps" `
    -Location "southafricanorth" `
    -VirtualNetworkName "az104vnet" `
    -SubnetName "Default" `
    -SecurityGroupName "az104sg" `
    -PublicIpAddressName "az104pubip" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest" `
    -Credential $cred `
    -AsJob

    az vm create -n az104vmcli -g az104cli --image ubuntults --size Standard_DS2_v2 --admin-username johan --admin-password Monst3rP@ssw0rd


    New-AzResourceGroupDeployment -ResourceGroupName az104ps -TemplateFile ./azuredeploy.json    
    az deployment group create --name CLIDeployment --resource-group az104-a --template-file azuredeploy.json

# Create nsg rule for VM
$RGname="az104ps"
$port=80
$rulename="allowAppPort$port"
$nsgname="sf-vnet-security"
$nsg = Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $RGname
# Add the inbound security rule.
$nsg | Add-AzNetworkSecurityRuleConfig -Name $rulename -Description "Allow app port" -Access Allow `
    -Protocol * -Direction Inbound -Priority 455 -SourceAddressPrefix "*" -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange $port
# Update the NSG.
$nsg | Set-AzNetworkSecurityGroup


az vm open-port --port 80 --resource-group az104cli --name az104cli

#Bicep
New-AzResourceGroupDeployment `
  -Name demoRGDeployment `
  -ResourceGroupName ExampleGroup `
  -TemplateFile main.bicep `
  -storageAccountType Standard_GRS `

  az deployment group create \
  --name demoRGDeployment \
  --resource-group ExampleGroup \
  --template-file main.bicep \
  --parameters storageAccountType=Standard_GRS
