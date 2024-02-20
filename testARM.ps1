$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"
$rgAIName = "rg-z-cplus-ai-p-001"
$rgCustomerName = "rg-z-cplus-emrl-p-001"
$sshKeyName = 'ssh-z-cplus-cus-ai-p-001'
$rgDBName = "rg-z-cplus-db-p-001"
# $sshKeyName = 'ssh-z-cplus-cus-db-p-001'
# Customer Resource Group and Resources

# Deploy the Infra Network Security Groups
$templateFile = "./NetworkSecurityGroup-Infra/nsg-template.json"
$templateParameterFile = "./NetworkSecurityGroup-Infra/nsg-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile
   
# Deploy Infra Virtual Network
$templateFile = "./VirtualNetwork-Infra/vnet-template.json"
$templateParameterFile = "./VirtualNetwork-Infra/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $templateParameterFile $globalParameterFile

$custName = "demo"
$rgCustomerName = "rg-z-cust-$($custName)-p-001"

   $templateFile = "./ResourceGroup/resourcegroup-template.json"
   az deployment sub create `
      --location $location `
      --template-file $templateFile `
      --parameters $globalParameterFile name=$rgCustomerName

   # Deploy the Customer VM
   $customerVMName = "vm-z-$($custName)-p"
   $customerNICName = "$customerVMName-nic"
   $customerSubNetName = "sn-z-cplus-$($custName)"
   $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
   $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
   az deployment group create `
      --resource-group $rgCustomerName `
      --template-file $templateFile `
      --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
      subnetName=$customerSubNetName infraResourceGroupName=$rgInfraName vmSize='Standard_D4s_v5'