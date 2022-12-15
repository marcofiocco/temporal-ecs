#!/bin/bash

[ -z "$1" ] && echo "No ENV Name argument supplied" && exit 1

Env=$1

SvcName="temporal-svc"
AppName="temporal-app"

UISvcName="temporal-web-svc"

echo "Server Name: $AppName"
echo "UI Name: $UISvcName"
echo "Env Name: $Env"
echo "Service Name: $SvcName"

TemporalAddress="$SvcName.$Env.$AppName.local:7233"

echo "Deploying $SvcName"
copilot svc deploy --name "$SvcName" -e "$Env"

echo "Deploying $UISvcName"
copilot svc deploy --name "$UISvcName" -e "$Env"
