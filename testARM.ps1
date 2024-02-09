$environment = "dev"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-n-001"
$sshKeyName = "ssh-z-cplus-cus-db-n-001"

$customers = @( 
@{'name'='publ';"size" = "Standard_D4_v4"})

foreach ( $customer in $customers ) {
   $rgCustomerName = "rg-z-cplus-$($customer.name)-p-001"

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