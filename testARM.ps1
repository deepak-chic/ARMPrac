$environment = "dev"
$globalParameterFile = "./global-parameters.$environment.json"
$rgInfraName = "rg-z-cplus-infra-n-001"

# $templateFile = "./LoadBalancer/lb-template.json"
# #$templateParameterFile = "./VirtualNetwork/vnet-template-parameters.$environment.json"
# az deployment group create `
#    --resource-group $rgInfraName `
#    --template-file $templateFile `
#    --parameters $globalParameterFile

$customers = @( @{'name'='123';"size" = "098"}, @{'name'='456';"size" = "056"})

foreach($cust in $customers){
   echo $cust.name
   echo $cust.size
}