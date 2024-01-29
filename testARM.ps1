$templateFile = "./VirtualMachine/SSHTemplate/ssh-template.json"
$sshPublicKey = Get-Content "./VirtualMachine/public_ssh_key.pub" -Raw

ssh_public_key
az deployment group create `
   --resource-group 'rg-z-cplus-infra-n-001' `
   --template-file $templateFile `
   --parameters ssh_public_key=$sshPublicKey

$rgAIName = "rg-z-cplus-ai-n-001"
az sshkey create --name "vm-z-aise-n-001-key" --resource-group $rgAIName