$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"
$rgAIName = "rg-z-cplus-ai-p-001"
$rgCustomerName = "rg-z-cplus-emrl-p-001"
$sshKeyName = 'ssh-z-cplus-cus-ai-p-001'
$rgDBName = "rg-z-cplus-db-p-001"
$sshKeyName = 'ssh-z-cplus-cus-db-p-001'
# Customer Resource Group and Resources
  
$customers = @( @{'name'='publ';"size" = "Standard_D4s_v5"}, 
@{'name'='emrl';"size" = "Standard_D4s_v5"},
@{'name'='huss';"size" = "Standard_D4s_v5"},
@{'name'='sdco';"size" = "Standard_D4s_v5"},
@{'name'='dscl';"size" = "Standard_D4s_v5"},
@{'name'='rsic';"size" = "Standard_D4s_v5"},
@{'name'='pens';"size" = "Standard_D4s_v5"},
@{'name'='bran';"size" = "Standard_D4s_v5"},
@{'name'='star';"size" = "Standard_D4s_v5"},
@{'name'='nsgs';"size" = "Standard_D4s_v5"},
@{'name'='plum';"size" = "Standard_D4s_v5"},
@{'name'='sulo';"size" = "Standard_D4s_v5"}
)

foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cust-$($customer.name)-p-001"

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
