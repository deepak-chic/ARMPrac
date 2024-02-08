# Global Variables
$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
#================================================================================
# Hub Resource Group and resources

# Deploy the Hub Resource Group
$rgHubName = "rg-z-cplus-gw-p-001"

# Deploy Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgHubName

# Deploy the Hub Network Security Groups
$templateFile = "./NetworkSecurityGroup-Hub/nsg-template.json"
$templateParameterFile = "./NetworkSecurityGroup-Hub/nsg-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# Deploy Hub Virtual Network
$templateFile = "./VirtualNetwork-Hub/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Hub/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# Deploy the Public IPs
# $templateFile = "./PublicKeys/pk-template.json"
# $templateParameterFile = "./PublicKeys/pk-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

# # Deploy the Bastion
# $templateFile = "./Bastion/bastion-template.json"
# $templateParameterFile = "./Bastion/bastion-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $templateParameterFile $globalParameterFile

#==================================================================================
# Infra Resource Group and Resources
$rgInfraName = "rg-z-cplus-infra-p-001"

# Deploy the Infra Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgInfraName

# Deploy the Infra Network Security Groups
$templateFile = "./NetworkSecurityGroup-Infra/nsg-template.json"
$templateParameterFile = "./NetworkSecurityGroup-Infra/nsg-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile
   
# Deploy Infra Virtual Network
$templateFile = "./VirtualNetwork/vnet-template.json"
$templateParameterFile = "./VirtualNetwork/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

#=============================================================================================
# AI Resource Group and Resources
$rgAIName = "rg-z-cplus-ai-p-001"
$sshKeyName = 'ssh-z-cplus-cus-ai-p-001'

# Create the resource group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgAIName

# Generate the SSH key
$templateFile = "./VirtualMachine/SSHTemplate/ssh-template.json"
$sshPublicKey = Get-Content "./VirtualMachine/public_ssh_key.pub" -Raw
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile sshKeyName=$sshKeyName sshPublicKeyValue=$sshPublicKey

# Deploy the AI reciver VM
$templateFile = "./VirtualMachine/Linux/vm-aire-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-aire-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the ProAct service VM
$templateFile = "./VirtualMachine/Linux/vm-aise-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-aise-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the redis VM
$templateFile = "./VirtualMachine/Linux/vm-redis-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-redis-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# # #=============================================================================================
# DB Resource Group and Resources

$rgDBName = "rg-z-cplus-db-n-001"
$sshKeyName = 'ssh-z-cplus-cus-db-n-001'

# Create the resource group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgDBName

# Generate the SSH key
$templateFile = "./VirtualMachine/SSHTemplate/ssh-template.json"
$sshPublicKey = Get-Content "./VirtualMachine/public_ssh_key.pub" -Raw
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile sshKeyName=$sshKeyName sshPublicKeyValue=$sshPublicKey

# Deploy the Oracle DB VM
$templateFile = "./VirtualMachine/Db/vm-orad-template.json"
$templateParameterFile = "./VirtualMachine/Db/vm-orad-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

# Deploy the SQL DB VM
$templateFile = "./VirtualMachine/Db/vm-sql-template.json"
$templateParameterFile = "./VirtualMachine/Db/vm-sql-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName

# #=============================================================================================
# Customer Resource Group and Resources

$customers = @( @{'name'='publ';"size" = "Standard_D4_v4"}, 
@{'name'='groc';"size" = "Standard_D4_v4"}, 
@{'name'='cole';"size" = "Standard_E4as_v5"}, 
@{'name'='amaz';"size" = "Standard_E8as_v5"}, 
@{'name'='amsk';"size" = "Standard_E8as_v5"}, 
@{'name'='meij';"size" = "Standard_E8as_v5"}, 
@{'name'='whol';"size" = "Standard_D8_v4"}, 
@{'name'='waca';"size" = "Standard_D8_v4"}, 
@{'name'='cobo';"size" = "Standard_D2_v4"}, 
@{'name'='emrl';"size" = "Standard_E4as_v5"})

foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cplus-$($customer.name)-n-001"

   $templateFile = "./ResourceGroup/resourcegroup-template.json"
   az deployment sub create `
      --location $location `
      --template-file $templateFile `
      --parameters $globalParameterFile name=$rgCustomerName

   # Deploy the Customer VM
   $customerVMName = "vm-z-$($customer.name)-p"
   $customerNICName = "$customerVMName-nic"
   $customerSubNetName = "sn-z-cplus-$($customer.name)"
   $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
   $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
   az deployment group create `
      --resource-group $rgCustomerName `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
      subnetName=$customerSubNetName infraResourceGroupName=$rgInfraName vmSize=$($customer.size)
}

# ======================================================================================

# Other Infra Resources

# Deploy Key vault
$templateFile = "./Keyvault/kv-template.json"
$templateParameterFile = "./Keyvault/kv-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy Storage Account
$templateFile = "./StorageAccount/sa-template.json"
$templateParameterFile = "./StorageAccount/sa-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the API Management
$templateFile = "./APIManagementService/apim-template.json"
$templateParameterFile = "./APIManagementService/apim-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the Application gateway
$templateFile = "./ApplicationGetway/ag-template.json"
$templateParameterFile = "./ApplicationGetway/ag-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the VPN Gateway
$templateFile = "./VPNGateway/vpngw-template.json"
$templateParameterFile = "./VPNGateway/vpngw-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# Deploy the Load Balancer
$templateFile = "./LoadBalancer/lb-template.json"
$templateParameterFile = "./LoadBalancer/lb-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile
Write-Output "Done the Infra"


