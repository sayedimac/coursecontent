Azure Compute Solutions
Azure Virtual Machines
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new resource group
New-AzResourceGroup -Name "YourResourceGroup" -Location "EastUS"

# Create a new virtual machine
New-AzVM -ResourceGroupName "YourResourceGroup" -Name "YourVM" -Location "EastUS" -VirtualNetworkName "YourVNet" -SubnetName "YourSubnet" -SecurityGroupName "YourNSG" -PublicIpAddressName "YourPublicIP" -OpenPorts 80,3389
CLI Script:

# Login to your Azure account
az login

# Create a new resource group
az group create --name YourResourceGroup --location eastus

# Create a new virtual machine
az vm create --resource-group YourResourceGroup --name YourVM --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
Azure App Services
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new App Service plan
New-AzAppServicePlan -ResourceGroupName "YourResourceGroup" -Name "YourAppServicePlan" -Location "EastUS" -Tier "Standard" -NumberofWorkers 1

# Create a new web app
New-AzWebApp -ResourceGroupName "YourResourceGroup" -Name "YourWebApp" -AppServicePlan "YourAppServicePlan"
CLI Script:

# Login to your Azure account
az login

# Create a new App Service plan
az appservice plan create --name YourAppServicePlan --resource-group YourResourceGroup --sku S1

# Create a new web app
az webapp create --name YourWebApp --resource-group YourResourceGroup --plan YourAppServicePlan
Azure Functions
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new Function App
New-AzFunctionApp -ResourceGroupName "YourResourceGroup" -Name "YourFunctionApp" -StorageAccountName "YourStorageAccount" -AppServicePlan "YourAppServicePlan" -Runtime "dotnet"
CLI Script:

# Login to your Azure account
az login

# Create a new Function App
az functionapp create --resource-group YourResourceGroup --consumption-plan-location eastus --runtime dotnet --functions-version 3 --name YourFunctionApp --storage-account YourStorageAccount
Azure Storage
Azure Blob Storage
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new storage account
New-AzStorageAccount -ResourceGroupName "YourResourceGroup" -Name "YourStorageAccount" -Location "EastUS" -SkuName "Standard_LRS"

# Create a new blob container
$context = New-AzStorageContext -StorageAccountName "YourStorageAccount" -StorageAccountKey (Get-AzStorageAccountKey -ResourceGroupName "YourResourceGroup" -Name "YourStorageAccount").Value
New-AzStorageContainer -Name "YourContainer" -Context $context
CLI Script:

# Login to your Azure account
az login

# Create a new storage account
az storage account create --name YourStorageAccount --resource-group YourResourceGroup --location eastus --sku Standard_LRS

# Create a new blob container
az storage container create --name YourContainer --account-name YourStorageAccount
Azure Security
Azure Key Vault
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new Key Vault
New-AzKeyVault -ResourceGroupName "YourResourceGroup" -VaultName "YourKeyVault" -Location "EastUS"
CLI Script:

# Login to your Azure account
az login

# Create a new Key Vault
az keyvault create --name YourKeyVault --resource-group YourResourceGroup --location eastus
Web Apps and APIs
Azure API Management
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new API Management service
New-AzApiManagement -ResourceGroupName "YourResourceGroup" -Name "YourApiManagement" -Location "EastUS" -Organization "YourOrganization" -AdminEmail "admin@yourdomain.com"
CLI Script:

# Login to your Azure account
az login

# Create a new API Management service
az apim create --name YourApiManagement --resource-group YourResourceGroup --location eastus --publisher-email admin@yourdomain.com --publisher-name YourOrganization
Event and Message-Based Solutions
Azure Event Grid
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new Event Grid topic
New-AzEventGridTopic -ResourceGroupName "YourResourceGroup" -Name "YourTopic" -Location "EastUS"

# Create a new Event Grid subscription
New-AzEventGridSubscription -ResourceGroupName "YourResourceGroup" -TopicName "YourTopic" -Endpoint "https://yourendpoint.com"
CLI Script:

# Login to your Azure account
az login

# Create a new Event Grid topic
az eventgrid topic create --resource-group YourResourceGroup --name YourTopic --location eastus

# Create a new Event Grid subscription
az eventgrid event-subscription create --resource-group YourResourceGroup --topic-name YourTopic --name YourSubscription --endpoint https://yourendpoint.com
Monitoring and Troubleshooting
Azure Monitor
PowerShell Script:

# Connect to your Azure account
Connect-AzAccount

# Create a new Log Analytics workspace
New-AzOperationalInsightsWorkspace -ResourceGroupName "YourResourceGroup" -Name "YourWorkspace" -Location "EastUS" -Sku "PerGB2018"

# Enable monitoring for a virtual machine
Set-AzVMExtension -ResourceGroupName "YourResourceGroup" -VMName "YourVM" -Name "OmsAgentForLinux" -Publisher "Microsoft.EnterpriseCloud.Monitoring" -Type "OmsAgentForLinux" -TypeHandlerVersion "1.0" -Settings @{ "workspaceId" = (Get-AzOperationalInsightsWorkspace -ResourceGroupName "YourResourceGroup" -Name "YourWorkspace").CustomerId }
CLI Script:

# Login to your Azure account
az login

# Create a new Log Analytics workspace
az monitor log-analytics workspace create --resource-group YourResourceGroup --workspace-name YourWorkspace --location eastus

# Enable monitoring for a virtual machine
az vm extension set --resource-group YourResourceGroup --vm-name YourVM --name OmsAgentForLinux --publisher Microsoft.EnterpriseCloud.Monitoring --settings '{"workspaceId": "$(az monitor log-analytics workspace show --resource-group YourResourceGroup --workspace-name YourWorkspace --query customerId --output tsv)"}'
