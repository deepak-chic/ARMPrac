$environment = "prod"
$location = "centralus"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-p-001"

$rgHubName = "rg-z-cplus-gw-p-001"

# # Deploy the API Management
# $templateFile = "./APIManagementService/apim-template.json"
# $templateParameterFile = "./APIManagementService/apim-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile $templateParameterFile

# Deploy the Application gateway
$templateFile = "./ApplicationGetway/ag-template.json"
$templateParameterFile = "./ApplicationGetway/ag-template-parameters.$environment.json"
az deployment group create `
   --resource-group $rgHubName `
   --template-file $templateFile `
   --parameters $globalParameterFile $templateParameterFile

# # Deploy the VPN Gateway
# $templateFile = "./VPNGateway/vpngw-template.json"
# $templateParameterFile = "./VPNGateway/vpngw-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgHubName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile $templateParameterFile


