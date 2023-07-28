echo "Install kubectl ..."
sudo az aks install-cli
sudo chown -R azureuser /var/run/docker
echo "Install helm ..." >> $log
curl -o helm.tar.gz https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz
tar zxvf helm.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64
rm -f helm.tar.gz
echo "login with VMSS Manage Identity ..."
az login --identity
echo "Connect to Cluster"
az aks get-credentials --name aks-cnsp-dev-weu --resource-group rg-cnsp-dev-weu-mkrou --overwrite-existing 
