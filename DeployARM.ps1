# Global Variables
$environment = "dev"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
#================================================================================

# Infra Resource Group and Resources
$rgInfraName = "rg-z-cplus-infra-n-001"

# Deploy Resource Group
$templateFile = "./ResourceGroup/resourcegroup-template.json"
az deployment sub create `
   --location $location `
   --template-file $templateFile `
   --parameters $globalParameterFile name=$rgInfraName

# Deploy Virtual Network
$templateFile = "./VirtualNetwork/vnet-template.json"
$templateParameterFile = "./VirtualNetwork/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

# Deploy the Public IP regarding bastion
$templateFile = "./PublicKeys/bastion-pk.json"
$templateParameterFile = "./PublicKeys/bastion-pk-parameters.$environment.json"
az deployment group create --resource-group $rgInfraName --template-file $templateFile --parameters $templateParameterFile location=$location

# Deploy the Bastion
$templateFile = "./Bastion/bastion-template.json"
$templateParameterFile = "./Bastion/bastion-template-parameters.$environment.json"
az deployment group create --resource-group $rgInfraName --template-file $templateFile --parameters $templateParameterFile location=$location
#=============================================================================================

# AI Resource Group and Resources
$rgAIName = "rg-z-cplus-ai-n-001"
$sshKeyName = 'ssh-z-cplus-cus-ai-n-001'

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

$customers = @('plum', 'nstg')
foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cplus-$customer-n-001"

   $templateFile = "./ResourceGroup/resourcegroup-template.json"
   az deployment sub create `
      --location $location `
      --template-file $templateFile `
      --parameters $globalParameterFile name=$rgCustomerName

   # Deploy the Oracle DB VM
   $customerVMName = "vm-z-$customer-n"
   $customerNICName = "$customerVMName-nic"
   $customerSubNetName = "sn-z-cplus-$customer"
   $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
   $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
   az deployment group create `
      --resource-group $rgCustomerName `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
      subnetName=$customerSubNetName
}

Write-Output "Done the Infra"

