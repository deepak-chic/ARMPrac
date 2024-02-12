$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"

# DB Resource Group and Resources

# # Deploy the SQL DB VM
# $templateFile = "./VirtualMachine/Db/vm-sql-template.json"
# $templateParameterFile = "./VirtualMachine/Db/vm-sql-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgDBName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile $templateParameterFile infraResourceGroupName=$rgInfraName

$rgHubName = "rg-z-cplus-gw-p-001"

# Deploy the Application gateway
$templateFile = "./APIManagementService/apim-template.json"
$templateParameterFile = "./APIManagementService/apim-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile