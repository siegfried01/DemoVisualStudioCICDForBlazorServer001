/*


   // https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-quickstart-task-cli#build-and-push-image-from-a-dockerfile
   // https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-build
   // https://learn.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

   Begin common prolog commands
   export name=DemoVisualStudioCICDForBlazorServer
   export registry=`perl -e '$_ = shift; print lc;' $name`
   export image=image`perl -e '$_ = shift; print lc;' $name`
   export plan=plan_`perl -e '$_ = shift; print lc;' $name`
   export rg=rg_$name
   export web=web3$name
   export repo=sample
   export loc=westus2
   export busNS=sbdemo001NS
   export queue=mainqueue001
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo "Previous build is complete. Begin deployment build."
   #az deployment group create --name $name --resource-group $rg   --template-file  deploy-DemoVisualStudioCICDForBlazorServer-via-ACR.bicep
   az acr create --resource-group $rg --name $registry  --sku Basic --admin-enabled true
   #az acr update -n demovisualstudiocicdforblazorserver --admin-enabled true
   echo end deploy
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with bash
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   echo "begin shutdown"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   az resource list --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   echo "showdown is complete"
   End commands to shut down this deployment using Azure CLI with bash

   emacs ESC 3 F10
   Begin commands for one time initializations using Azure CLI with bash
   az group create -l $loc -n $rg
   export id=`az group show --name $rg --query 'id' --output tsv`
   echo "id=$id"
   export sp="spad_$name"
   #az ad sp create-for-rbac --name $sp --sdk-auth --role contributor --scopes $id
   #echo "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   cat >clear-resources.json <<EOF
   {
    "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
     "contentVersion": "1.0.0.0",
     "resources": [] 
   }
   EOF
   End commands for one time initializations using Azure CLI with bash

   emacs ESC 4 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az acr build -g $rg --image $repo/$image:v1 --registry $registry --file Dockerfile . 
   az acr build -g $rg --image $repo/$image:v1 --registry $registry --file Dockerfile .
   End commands to deploy this file using Azure CLI with bash
    
   emacs ESC 5 F10
   Begin commands to deploy this file using Azure CLI with bash
   az acr repository list -n $registry
   End commands to deploy this file using Azure CLI with bash
   
   emacs ESC 6 F10
   Begin commands to deploy this file using Azure CLI with bash
   password=`az acr credential show --resource-group $rg --name demovisualstudiocicdforblazorserver --query passwords[0].value --output tsv`
   echo password=$password
   username=`az acr credential show --resource-group $rg --name demovisualstudiocicdforblazorserver --query username  --output tsv`
   echo username=$username
   echo az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku B1
   az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku B1
   echo az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name demovisualstudiocicdforblazorserver.azurecr.io/$repo/$image:v1 
   az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name demovisualstudiocicdforblazorserver.azurecr.io/$repo/$image:v1 -s $username -w $password
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 7 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az servicebus namespace create --resource-group $rg --name $busNS --location $loc
   az servicebus namespace create --resource-group $rg --name $busNS --location $loc
   echo az servicebus queue create --resource-group $rg --namespace-name $busNS --name $queue
   az servicebus queue create --resource-group $rg --namespace-name $busNS --name $queue
   echo az servicebus namespace authorization-rule keys list --resource-group $rg --namespace-name $busNS --name RootManageSharedAccessKey --query primaryConnectionString --output tsv
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 8 F10
   Begin commands to deploy this file using Azure CLI with bash
   export sbconn=`az servicebus namespace authorization-rule keys list --resource-group $rg --namespace-name $busNS --name RootManageSharedAccessKey --query primaryConnectionString --output tsv`
   dotnet script servicebusinsertmsg.csx $busNS $queue
   End commands to deploy this file using Azure CLI with bash
*/
