#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl lsb-release gnupg-agent software-properties-common mysql-client
curl -fsSL https://get.docker.com -o get-docker.sh && sudo chmod +x get-docker.sh && ./get-docker.sh
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update -y
sudo apt-get install azure-cli -y
sudo az aks install-cli
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
sudo apt  install jq
# mkdir actions-runner
# cd actions-runner
# curl -o actions-runner-linux-x64-2.307.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.307.1/actions-runner-linux-x64-2.307.1.tar.gz
# tar xzf ./actions-runner-linux-x64-2.307.1.tar.gz
# token=`curl -L -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer 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" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/MaryKroustali/bicep/actions/runners/registration-token`
# token=`echo $token | jq -r '.token'`
# echo | ./config.sh --url https://github.com/MaryKroustali/bicep --token $token
# sudo ./svc.sh install
# sudo ./svc.sh start
