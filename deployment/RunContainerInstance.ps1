
$pw = $env:repoPassword
$un = $env:repoUser

$pw = $pw | ConvertTo-SecureString -AsPlainText -Force

$azure_registry_credential = New-Object System.Management.Automation.PSCredential -ArgumentList $un, $pw 

New-AzContainerGroup -ResourceGroupName $env:resourceGroup -Name "containerRun" -Image "$env:containerImage" -Location "Southeast Asia" -RegistryCredential $azure_registry_credential -RestartPolicy OnFailure -Cpu 1 -MemoryInGB 0.1 


