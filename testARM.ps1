$environment = "dev"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-n-001"

$templateFile = "./PublicKeys/pk-template.json"
$templateParameterFile = "./PublicKeys/pk-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

$templateFile = "./APIManagementService/apim-template.json"
#$templateParameterFile = "./VirtualNetwork/vnet-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgInfraName `
   --template-file $templateFile `
   --parameters $globalParameterFile

