/*


   // https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-quickstart-task-cli#build-and-push-image-from-a-dockerfile
   // https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-build
   // https://learn.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

   Begin common prolog commands
   export APPSERVICE_SKU=FREE
   export name=DemoVisualStudioCICDForBlazorServer
   export registry=`perl -e '$_ = shift; print lc;' $name`
   export plan=plan_`perl -e '$_ = shift; print lc;' $name`
   export rg=rg_${name} 
   export WEB=web3${name}
   export loc=westus
   export DOCKERHUB_USERNAME=siegfried01
   export DOCKERHUB_REPO=demovisualstudiocicdforblazorserver
   export DOCKER_IMAGE=demovisualstudiocicdforblazorserver
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo "Previous build is complete. Begin deployment build."
   echo docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
   docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
   echo docker build -t $DOCKER_IMAGE:1 .
   docker build -t $DOCKER_IMAGE:1 .
   echo docker tag $DOCKER_IMAGE:1 $DOCKERHUB_USERNAME/$DOCKER_IMAGE:1
   docker tag $DOCKER_IMAGE:1 $DOCKERHUB_USERNAME/$DOCKER_IMAGE:1
   echo docker push $DOCKERHUB_USERNAME/$DOCKER_IMAGE:1
   docker push $DOCKERHUB_USERNAME/$DOCKER_IMAGE:1
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with bash
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   echo "begin shutdown"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   echo list resources for $rg
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
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   echo az webapp create  --name $WEB --resource-group  $rg  --plan $plan --deployment-container-image-name $DOCKERHUB_REPO/$DOCKER_IMAGE -s $DOCKERHUB_USERNAME -w $DOCKERHUB_PASSWORD
   az webapp create  --name $WEB --resource-group  $rg  --plan $plan --deployment-container-image-name $DOCKERHUB_REPO/$DOCKER_IMAGE -s $DOCKERHUB_USERNAME -w $DOCKERHUB_PASSWORD
   #az webapp config appsettings set  --resource-group $rg  --name $WEB  --settings  "TITLE=Deployed via Azure CLI and Dockerhub"
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

*/
