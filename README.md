<img src="https://raw.githubusercontent.com/Sufi-Dev/Blue-Green-Deployment/main/BlueGreens.png" >

## Project Info <img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/info.gif" width="30" height="30">

Blue-green deployment is a way to reduce downtime and risk by running two production environments, called "Blue" and "Green," that are exactly the same. <br>
In this project, I used Terraform to automate how Infrastructure was set up in Azure for both Blue and Green environments.
<br>


## Project Map <img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/map.png" width="30" height="30">
The files for Terraform are split into two folders.
1. `Blue-Green-Deployment`: This folder has all the Terraform files that are used to set up two identical environments in two different Azure resource groups. Web servers hosted in Azure Virtual Scale Set were among the resources that were set up. <br>
I used `workspaces` to keep the settings for each resource group separate.<br>
In terraform, `workspaces` are separate copies of state data that can be used from the same working directory. You can use workspaces to manage different groups of resources that don't overlap but have the same settings.
```terraform
# Switch first to the green workspace and then deploy 
terraform workspace select green  
terraform plan 
terraform apply -auto-approve 
```

```terraform
# Switch first to the blue workspace and then deploy 
terraform workspace select blue
terraform plan
terraform apply -auto-approve 
```
2. `Gateway Deployment`: All the Terraform files required to set up the backend database servers can be found in this directory. When the Green environment is up and running, traffic is routed through the traffic manager, which switches to the Blue resource group when the Green environment goes down.
## Tools 🛠
<img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/azure.svg" alt="azure" width="40" height="20"/> Azure
<img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/terraform.svg" alt="azure" width="40" height="20"/> Terraform
<img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/linux.svg" alt="linux" width="40" height="20"/> Linux 
<img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/nosql.svg" alt="azure" width="40" height="20"/> NoSQL
<img src="https://raw.githubusercontent.com/Sufi-Dev/Sufi-Dev/main/icons/ansible.svg" width="40" height="20" /> Ansible


## Related Pojects 🔗
Checkout the project where I fully automated CI/CD pipeline in Azure DevOps. see below link<br>
[Designed & deployed fully automated CI/CD in Azure DevOps](https://github.com/Sufi-Dev/weatherapi)
