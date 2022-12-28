/*


   // https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-quickstart-task-cli#build-and-push-image-from-a-dockerfile
   // https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-build
   // https://learn.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

   Begin common prolog commands
   export APPSERVICE_SKU=FREE
   export name=DemoVisualStudioCICDForBlazorServer
   export registry=reg2j6dkjc5s4m4q
   export image=img_dvscicdbs
   export plan=2j6dkjc5s4m4q-plan
   export rg=rg_${name}
   export web=2j6dkjc5s4m4q-web
   export repo=sample
   export loc=westus
   export busNS=sbdemo001NS
   export queue=mainqueue001
   export DOCKERHUB_USERNAME=siegfried01
   export password=`az acr credential show --resource-group $rg --name $registry --query passwords[0].value --output tsv | sed 's/\r$//'`
   export username=`az acr credential show --resource-group $rg --name $registry --query username  --output tsv | sed 's/\r$//'`
   echo username=$username password=$password
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo "Previous build is complete. Begin deployment build."
   #az deployment group create --name $name --resource-group $rg   --template-file  deploy-DemoVisualStudioCICDForBlazorServer-via-ACR.bicep
   echo az acr create --resource-group $rg --name $registry  --sku Basic --admin-enabled true
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

   Build image with ACR and deploy from ACR: alternatively you can use a local build and docker push below. Both work
   emacs ESC 4 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az acr build -g $rg --image $repo/$image:v1 --registry $registry --file Dockerfile . 
   az acr build -g $rg --image $repo/$image:v1 --registry $registry --file Dockerfile .
   az acr repository list -n $registry
   export password=`az acr credential show --resource-group $rg --name $registry --query passwords[0].value --output tsv | sed 's/\r$//'`
   export username=`az acr credential show --resource-group $rg --name $registry --query username  --output tsv | sed 's/\r$//'`
   echo password=$password
   echo username=$username
   echo az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   echo az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name $registry.azurecr.io/$repo/$image:v1 
   az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name $registry.azurecr.io/$repo/$image:v1 -s $username -w $password
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   create service bus to provide metrics for autoscaler demoonstration
   emacs ESC 5 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az servicebus namespace create --resource-group $rg --name $busNS --location $loc
   az servicebus namespace create --resource-group $rg --name $busNS --location $loc
   echo az servicebus queue create --resource-group $rg --namespace-name $busNS --name $queue
   az servicebus queue create --resource-group $rg --namespace-name $busNS --name $queue
   echo az servicebus namespace authorization-rule keys list --resource-group $rg --namespace-name $busNS --name RootManageSharedAccessKey --query primaryConnectionString --output tsv
   End commands to deploy this file using Azure CLI with bash

   run the service bus to provide metrics
   emacs ESC 6 F10
   Begin commands to deploy this file using Azure CLI with bash
   export sbconn=`az servicebus namespace authorization-rule keys list --resource-group $rg --namespace-name $busNS --name RootManageSharedAccessKey --query primaryConnectionString --output tsv`
   dotnet script servicebusinsertmsg.csx $busNS $queue
   End commands to deploy this file using Azure CLI with bash

   Begin alternate steps: Build image locally. docker login works with dockerhub credentials..
   emacs ESC 7 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo docker build -t $image .
   docker build -t $image .
   export password=`az acr credential show --resource-group $rg --name $registry --query passwords[0].value --output tsv | sed 's/\r$//'`
   export username=`az acr credential show --resource-group $rg --name $registry --query username  --output tsv | sed 's/\r$//'`
   #az acr login -n $registry -u $username -p $password
   echo $password | docker login  $registry.azurecr.io -u $username --password-stdin
   #$password | docker login  $registry.azurecr.io -u $username --password-stdin
   #docker login $registry.azurecr.io -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
   echo az acr login -n $registry -u $username -p $password
   az acr login -n $registry -u $username -p $password
   echo docker login $registry.azurecr.io
   #docker login $registry.azurecr.io
   #echo docker tag $image:latest $registry.azurecr.io/$repo/$image:latest
   docker tag $image:latest $registry.azurecr.io/$repo/$image:latest
   End commands to deploy this file using Azure CLI with bash

   Alternate step: push to ACR
   emacs ESC 8 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo $password | docker login  $registry.azurecr.io -u $username --password-stdin
   echo docker push $registry.azurecr.io/$repo/$image:latest
   docker push $registry.azurecr.io/$repo/$image:latest
   echo az acr repository list -n $registry
   az acr repository list -n $registry
   End commands to deploy this file using Azure CLI with bash

   Create the App Service Plan
   emacs ESC 9 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   End commands to deploy this file using Azure CLI with bash
   
   Create web server with custom container of custom code
   emacs ESC 10 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name $registry.azurecr.io/$repo/$image:latest --docker-registry-server-user $username --docker-registry-server-password $password
   az webapp create  --name $web --resource-group  $rg  --plan $plan --deployment-container-image-name $registry.azurecr.io/$repo/$image:latest --docker-registry-server-user $username --docker-registry-server-password $password
   End commands to deploy this file using Azure CLI with bash

   Deploy empty web server with no custom code and deploy container in next step
   emacs ESC 11 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp create  --name $web --resource-group  $rg  --plan $plan --runtime "DOTNETCORE:7.0"
   az webapp create  --name $web --resource-group  $rg  --plan $plan --runtime "DOTNETCORE:7.0"
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   deploy custom container
   emacs ESC 12 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp config container set --docker-custom-image-name $registry.azurecr.io/$repo/$image:latest -n $web -g $rg --docker-registry-server-password $password  --docker-registry-server-user $username
   az webapp config container set --docker-custom-image-name $registry.azurecr.io/$repo/$image:latest -n $web -g $rg --docker-registry-server-password $password  --docker-registry-server-user $username
   End commands to deploy this file using Azure CLI with bash

   Delete the web site
   emacs ESC 13 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp delete -n $web -g $rg --keep-empty-plan
   az webapp delete -n $web -g $rg --keep-empty-plan
   End commands to deploy this file using Azure CLI with bash
   
   list candidate runtimes 
   emacs ESC 14 F10
   Begin commands to deploy this file using Azure CLI with bash
   az webapp list-runtimes
   End commands to deploy this file using Azure CLI with bash
   
   Experiment with docker login
   emacs ESC 15 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo $DOCKERHUB_PASWORD | docker login  $registry.azurecr.io -u $DOCKERHUB_USERNAME --password-stdin
   $DOCKERHUB_PASWORD | docker login  $registry.azurecr.io -u $DOCKERHUB_USERNAME --password-stdin
   export password=`az acr credential show --resource-group $rg --name $registry --query passwords[0].value --output tsv | sed 's/\r$//'`
   export username=`az acr credential show --resource-group $rg --name $registry --query username  --output tsv | sed 's/\r$//'`
   echo username=$username password=$password
   echo az acr login -n $registry -u $username -p $password
   az acr login -n $registry -u $username -p $password
   End commands to deploy this file using Azure CLI with bash

   add app insights
   emacs ESC 16 F10
   Begin commands to deploy this file using Azure CLI with bash
   az monitor app-insights component create --app demoApp --location $loc --kind web --resource-group $rg --application-type web
   End commands to deploy this file using Azure CLI with bash

    
*/
