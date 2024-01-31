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

# download azdo agent
echo "Install Azure DevOps agent ..." >> $log
sudo mkdir -p /opt/azdo && cd /opt/azdo
cd /opt/azdo
sudo curl -o azdoagent.tar.gz https://vstsagentpackage.azureedge.net/agent/3.225.0/vsts-agent-linux-x64-3.225.0.tar.gz
sudo tar xzvf azdoagent.tar.gz
sudo rm -f azdoagent.tar.gz

# configure as azdouser
echo "Configure Azure DevOps agent ..." >> $log
sudo chown -R $agentuser /opt/azdo
sudo chmod -R 755 /opt/azdo
runuser -l $agentuser -c "/opt/azdo/config.sh --unattended --url $azdourl --auth pat --token $pat --pool $pool --acceptTeeEula"

# install and start the service
echo "Configure Azure DevOps agent to run as a service ..." >> $log
sudo /opt/azdo/svc.sh install
sudo /opt/azdo/svc.sh start

# give permissions to run pipeline
echo "Configure Azure DevOps agent to run Docker scripts ..." >> $log
sudo chown -R $agentuser /var/run/docker
