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
sudo mkdir myagent && cd myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/3.232.3/vsts-agent-win-x64-3.232.3.zip
sudo tar zxvf vsts-agent-win-x64-3.232.3.zip
sudo rm -f vsts-agent-win-x64-3.232.3.zip

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
sudo chown -R $agentuser myagent/docker
