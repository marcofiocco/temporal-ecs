#!/bin/bash

[ -z "$1" ] && echo "No ENV Name argument supplied" && exit 1

Env=$1
AppName="temporal-app"
SvcName="temporal-svc"
UISvcName="temporal-web-svc"

echo "Server Name: $AppName"
echo "UI Name: $UISvcName"
echo "Env Name: $Env"
echo "Service Name: $SvcName"

TemporalAddress="$SvcName.$Env.$AppName.local:7233"

mkdir -p copilot/$SvcName/addons
cp base/serverManifest.yml copilot/$SvcName/manifest.yml
sed -i -r "s/someAppName/$SvcName/" copilot/$SvcName/manifest.yml
rm copilot/$SvcName/manifest.yml-r
cp base/database-cluster.yml copilot/$SvcName/addons/$SvcName-cluster.yml
#cp base/opensearch.yml copilot/$SvcName/addons/$SvcName-opensearch.yml

mkdir -p copilot/$UISvcName
cp base/uiManifest.yml copilot/$UISvcName/manifest.yml
sed -i -r "s/someUiName/$UISvcName/" copilot/$UISvcName/manifest.yml
sed -i -r "s/someTemporalAddress/$TemporalAddress/" copilot/$UISvcName/manifest.yml
rm copilot/$UISvcName/manifest.yml-r

copilot app init --permissions-boundary ADSK-Boundary --resource-tags adsk:moniker="RESGAD-C-UW2"

copilot env init --name $Env
copilot env deploy --name $Env # this creates the ECS cluster, security group and service discovery (Cloud Map)

copilot svc init -a "$AppName" -t "Load Balanced Web Service" -n "$SvcName" # this creates the load balancer, ECS service and addons

copilot svc init -a "$AppName" -t "Load Balanced Web Service" -n "$UISvcName" # this creates the load balancer, ECS service and addons

echo "Deploying $SvcName"
copilot svc deploy --name "$SvcName" -e "$Env" # this actually instantiates the resources

echo "Deploying $UISvcName"
copilot svc deploy --name "$UISvcName" -e "$Env" # this actually instantiates the resources
