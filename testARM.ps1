$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"

# DB Resource Group and Resources

$rgDBName = "rg-z-cplus-db-p-001"
$sshKeyName = 'ssh-z-cplus-cus-db-p-001'

# # Deploy the SQL DB VM
# $templateFile = "./VirtualMachine/Db/vm-sql-template.json"
# $templateParameterFile = "./VirtualMachine/Db/vm-sql-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgDBName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName


$templateFile = "./VirtualMachine/Db/vm-sql-template.json"
$templateParameterFile = "./VirtualMachine/Db/vm-sql-template-parameters.$environment.json"
$vmSizes = @('Standard_E8as_v5', 'Standard_E8as_v5', 'Standard_E8as_v5', 'Standard_E20as_v5', 'Standard_E20as_v5', 'Standard_E8as_v5')
$noOfInstance = $vmSizes.count
$counter = 1
while($counter -le $noOfInstance)
{
   $vmName = "vm-z-sqld-p-$($counter.ToString('000'))"
   $nicName = "$vmName-nic"
   
   az deployment group create `
   --resource-group $rgDBName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName `
   virtualMachineName=$vmName vmSize=$($vmSizes[$counter-1]) networkInterfacesName=$nicName

   $counter +=1
}
