# Login to Azure
az login
Connect-AzAccount

######################################
# Azure Identity and Governance      #
######################################
# Create Azure AD Group
az ad group create --display-name "MyGroup" --mail-nickname "MyGroup"
New-AzADGroup -DisplayName "MyGroup" -MailNickname "MyGroup"
# Update Azure AD Group
az ad group update --group "MyGroup" --display-name "MyUpdatedGroup"
Set-AzADGroup -ObjectId (Get-AzADGroup -DisplayName "MyGroup").Id -DisplayName "MyUpdatedGroup"

######################################
# Azure Storage                      #
######################################
# Create a Storage Account
az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS
New-AzStorageAccount -ResourceGroupName "myResourceGroup" -Name "mystorageaccount" -Location "eastus" -SkuName "Standard_LRS"
# Update Storage Account
az storage account update --name mystorageaccount --resource-group myResourceGroup --set accessTier=Cool
Set-AzStorageAccount -ResourceGroupName "myResourceGroup" -Name "mystorageaccount" -AccessTier "Cool"

# Azure Compute Resources
# Create a Virtual Machine
az vm create --resource-group myResourceGroup --name myVM --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
New-AzVM -ResourceGroupName "myResourceGroup" -Name "myVM" -Location "eastus" -VirtualNetworkName "myVnet" -SubnetName "mySubnet" -SecurityGroupName "myNSG" -PublicIpAddressName "myPublicIP" -OpenPorts 22
az vm update --resource-group myResourceGroup --name myVM --set tags.CostCenter=IT
Set-AzVM -ResourceGroupName "myResourceGroup" -Name "myVM" -Tag @{CostCenter = "IT" }

######################################
# Virtual Networking                 #
######################################
# Create a Virtual Network
az network vnet create --name myVnet --resource-group myResourceGroup --subnet-name mySubnet
New-AzVirtualNetwork -ResourceGroupName "myResourceGroup" -Location "eastus" -Name "myVnet" -AddressPrefix "10.0.0.0/16" -Subnet @{"Name" = "mySubnet"; "AddressPrefix" = "10.0.0.0/24" }
# Update Virtual Network
az network vnet update --name myVnet --resource-group myResourceGroup --address-prefixes 10.1.0.0/16
Set-AzVirtualNetwork -ResourceGroupName "myResourceGroup" -Name "myVnet" -AddressPrefix "10.1.0.0/16"

# Create a Network Security Group
az network nsg create --resource-group myResourceGroup --name myNSG
New-AzNetworkSecurityGroup -ResourceGroupName "myResourceGroup" -Location "eastus" -Name "myNSG"
# Update Network Security Group
az network nsg update --resource-group myResourceGroup --name myNSG --tags Environment=Production
Set-AzNetworkSecurityGroup -ResourceGroupName "myResourceGroup" -Name "myNSG" -Tag @{Environment = "Production" }

# Create a DNS Zone
az network dns zone create --resource-group myResourceGroup --name myzone.com
New-AzDnsZone -ResourceGroupName "myResourceGroup" -Name "myzone.com"
# Update DNS Zone
az network dns zone update --resource-group myResourceGroup --name myzone.com --tags Department=IT
Set-AzDnsZone -ResourceGroupName "myResourceGroup" -Name "myzone.com" -Tag @{Department = "IT" }

# Create a VPN Gateway
az network vnet-gateway create --resource-group myResourceGroup --name myVpnGateway --vnet myVnet --public-ip-address myPublicIP --gateway-type Vpn --vpn-type RouteBased --sku VpnGw1 --no-wait
New-AzVirtualNetworkGateway -ResourceGroupName "myResourceGroup" -Name "myVpnGateway" -Location "eastus" -IpConfigurations @{"Name" = "myVpnGatewayIpConfig"; "SubnetId" = "/subscriptions/{subscription-id}/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/GatewaySubnet"; "PublicIpAddressId" = "/subscriptions/{subscription-id}/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myPublicIP" }
# Update VPN Gateway
az network vnet-gateway update --resource-group myResourceGroup --name myVpnGateway --set tags.Project=Migration
Set-AzVirtualNetworkGateway -ResourceGroupName "myResourceGroup" -Name "myVpnGateway" -Tag @{Project = "Migration" }

# Create an ExpressRoute Circuit
az network express-route create --name myExpressRoute --resource-group myResourceGroup --peering-location "Silicon Valley" --bandwidth 200 --sku-family MeteredData --sku-tier Standard
New-AzExpressRouteCircuit -ResourceGroupName "myResourceGroup" -Name "myExpressRoute" -Location "eastus" -SkuTier "Standard" -SkuFamily "MeteredData" -ServiceProviderProperties @{"ServiceProviderName" = "Equinix"; "PeeringLocation" = "Silicon Valley"; "BandwidthInMbps" = 200 }
# Update ExpressRoute Circuit
az network express-route update --name myExpressRoute --resource-group myResourceGroup --set tags.Owner=Admin
Set-AzExpressRouteCircuit -ResourceGroupName "myResourceGroup" -Name "myExpressRoute" -Tag @{Owner = "Admin" }
