# Infra Resource Group and Resources
$rgInfraName = "rg-z-cplus-infra-n-001"
$location = "centralus"
$tags = "Cost Center=1108-300-8602"
az group create --name $rgInfraName --location $location --tags $tags

# Deploy Virtual Network
$templateFile = "./VirtualNetwork/vnet-template.json"
$templateParameterFile = "./VirtualNetwork/vnet-template-parameters.dev.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile location=$location

# Deploy the Public IP
$templateFile = "./PublicKeys/bastion-pk.json"
az deployment group create --resource-group $rgInfraName --template-file $templateFile

# Deploy the Bastion
$templateFile = "./Bastion/bastion-template.json"
az deployment group create --resource-group $rgInfraName --template-file $templateFile

# #=============================================================================================
# # AI Resource Group and Resources

$rgAIName = "rg-z-cplus-ai-n-001"
$sshPublicKey = Get-Content "./VirtualMachine/Linux/public_ssh_key.pub" -Raw

az group create --name $rgAIName --location $location --tags $tags

# Deploy the AI reciver VM
$templateFile = "./VirtualMachine/Linux/vm-aire.json"
az sshkey create --name "vm-z-aire-n-001-key" --resource-group $rgAIName --public-key $sshPublicKey --tags $tags | ConvertFrom-Json
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile

# Deploy the ProAct service VM
$templateFile = "./VirtualMachine/Linux/vm-aise.json"
az sshkey create --name "vm-z-aise-n-001-key" --resource-group $rgAIName --public-key $sshPublicKey --tags $tags | ConvertFrom-Json
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile

# # Deploy the redis VM
$templateFile = "./VirtualMachine/Linux/vm-redis.json"
az sshkey create --name "vm-z-redis-n-001-key" --resource-group $rgAIName --public-key $sshPublicKey --tags $tags | ConvertFrom-Json
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile

# #=============================================================================================
# DB Resource Group and Resources

$rgDBName = "rg-z-cplus-db-n-001"
$sshPublicKey = Get-Content "./VirtualMachine/Linux/public_ssh_key.pub" -Raw
az group create --name $rgDBName --location $location --tags $tags

# Deploy the Oracle DB VM
$templateFile = "./VirtualMachine/Db/vm-orad.json"
az sshkey create --name "vm-z-orad-n-001-key" --resource-group $rgDBName --public-key $sshPublicKey --tags $tags | ConvertFrom-Json
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile

# Deploy the SQL DB VM
$templateFile = "./VirtualMachine/Db/vm-sql.json"
az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile

#=============================================================================================
# Customer Resource Group and Resources

$customers = @('plum', 'nstg')
foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cplus-$customer-n-001"
   az group create --name $rgCustomerName --location $location --tags $tags

   # Deploy the Oracle DB VM
   $customerVM_Name = "vm-z-$customer-n"
   $customerNIC_Name = "$customerVM_Name-nic"
   $customerSubNet_Name = "sn-z-cplus-$customer"
   $templateFile = "./VirtualMachine/Customers/vm-customers.json"
   az deployment group create `
      --resource-group $rgCustomerName `
      --template-file $templateFile `
      --parameters virtualMachine_name=$customerVM_Name networkInterfaces_name=$customerNIC_Name `
      subnetName=$customerSubNet_Name
}

Write-Output "Done"

