$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"

# Customer Resource Group and Resources

# $customers = @( @{'name'='nsgs';"size" = "Standard_D4s_v5"}, 
# @{'name'='plum';"size" = "Standard_D4s_v5"}, 
# @{'name'='sulo';"size" = "Standard_E4as_v5"})

$rgAIName = "rg-z-cplus-ai-p-001"
   $rgCustomerName = "rg-z-cplus-emrl-p-001"
   $sshKeyName = 'ssh-z-cplus-cus-ai-p-001'
   # $templateFile = "./ResourceGroup/resourcegroup-template.json"
   # az deployment sub create `
   #    --location $location `
   #    --template-file $templateFile `
   #    --parameters $globalParameterFile name=$rgCustomerName

   # # Deploy the Customer VM
   # $customerVMName = "vm-z-emrl-p"
   # $customerNICName = "$customerVMName-nic"
   # $customerSubNetName = "sn-z-cplus-emrl"
   # $templateFile = "./VirtualMachine/Customers/vm-customers-template.json"
   # $templateParameterFile = "./VirtualMachine/Customers/vm-customers-template-parameters.$environment.json"
   # az deployment group create `
   #    --resource-group $rgCustomerName `
   #    --template-file $templateFile `
   #    --parameters $globalParameterFile $templateParameterFile virtualMachineName=$customerVMName networkInterfacesName=$customerNICName `
   #    subnetName=$customerSubNetName infraResourceGroupName=$rgInfraName vmSize='Standard_E4as_v5'

   
# Deploy the redis VM
$templateFile = "./VirtualMachine/Linux/vm-redis-template.json"
$templateParameterFile = "./VirtualMachine/Linux/vm-redis-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgAIName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName sshKeyName=$sshKeyName

