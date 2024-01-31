#!/bin/bash
# Initialize parameters specified from command line
while getopts ":u:p:t:l:" arg; do
    case "${arg}" in
        u)
            agentuser=${OPTARG}
        ;;
        p)
            pool=${OPTARG}
        ;;
        t)
            pat=${OPTARG}
        ;;
        l)
            azdourl=${OPTARG}
        ;;
    esac
done

# download unzip
sudo apt-get update
sudo apt-get install -y unzip

# download java 17
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
tar -xzf jdk-17_linux-x64_bin.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo mv jdk-17.0.10 /usr/lib/jvm/

# set JAVA environment
export JAVA_HOME=/usr/lib/jvm/jdk-17.0.10
export PATH=$JAVA_HOME/bin:$PATH

# download docker
sudo apt-get install -y apt-transport-https ca-certificates curl lsb-release gnupg-agent software-properties-common mysql-client
curl -fsSL https://get.docker.com -o get-docker.sh && sudo chmod +x get-docker.sh && ./get-docker.sh
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

# dowmload az cli
sudo apt-get update
sudo apt-get install azure-cli -y

# download azdo agent
echo "Install Azure DevOps agent ..." >> $log
sudo mkdir myagent && cd myagent
sudo curl https://vstsagentpackage.azureedge.net/agent/3.232.3/vsts-agent-linux-x64-3.232.3.tar.gz
sudo tar xzvf vsts-agent-linux-x64-3.232.3.tar.gz
sudo rm -f vsts-agent-linux-x64-3.232.3.tar.gz

# configure as azdouser
echo "Configure Azure DevOps agent ..." >> $log
sudo chown -R $agentuser myagent
sudo chmod -R 755 myagent
runuser -l $agentuser -c "myagent/config.sh --unattended --url $azdourl --auth pat --token $pat --pool $pool --acceptTeeEula"

# install and start the service
echo "Configure Azure DevOps agent to run as a service ..." >> $log
sudo myagent/svc.sh install
sudo myagent/svc.sh start

# give permissions to run pipeline
echo "Configure Azure DevOps agent to run Docker scripts ..." >> $log
sudo chown -R $agentuser /var/run/docker
