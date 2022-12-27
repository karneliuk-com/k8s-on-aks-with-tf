# Building AKS on Azure

## Steps
### Step 1. Install Azure CLI
[Official Documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

On the dev node:
```
$ apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
-------------------------------------------------------------------------------
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
ca-certificates is already the newest version (20210119).
curl is already the newest version (7.74.0-1.3+deb11u3).
gnupg is already the newest version (2.2.27-2+deb11u2).
gnupg set to manually installed.
lsb-release is already the newest version (11.1.0).
The following NEW packages will be installed:
  apt-transport-https
0 upgraded, 1 newly installed, 0 to remove and 53 not upgraded.
Need to get 160 kB of archives.
After this operation, 166 kB of additional disk space will be used.
Get:1 http://ftp.debian.org/debian bullseye/main amd64 apt-transport-https all 2.2.4 [160 kB]
Fetched 160 kB in 0s (2082 kB/s)        
Selecting previously unselected package apt-transport-https.
(Reading database ... 29735 files and directories currently installed.)
Preparing to unpack .../apt-transport-https_2.2.4_all.deb ...
Unpacking apt-transport-https (2.2.4) ...
Setting up apt-transport-https (2.2.4) ...
root@self-pod-999-ah:~# apt-get update -y
Get:1 http://security.debian.org bullseye-security InRelease [48.4 kB]
Hit:2 http://ftp.debian.org/debian bullseye InRelease
Get:3 http://ftp.debian.org/debian bullseye-updates InRelease [44.1 kB]
Hit:4 https://download.docker.com/linux/debian bullseye InRelease                     
Get:5 http://security.debian.org bullseye-security/main amd64 Packages [210 kB]       
Get:6 http://security.debian.org bullseye-security/main Translation-en [136 kB]
Fetched 438 kB in 1s (552 kB/s)                               
Reading package lists... Done


$ curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null


$ AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
-------------------------------------------------------------------------------
deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bullseye main


$ apt-get update -y
-------------------------------------------------------------------------------
Hit:1 http://security.debian.org bullseye-security InRelease
Hit:2 https://download.docker.com/linux/debian bullseye InRelease                                          
Hit:3 http://ftp.debian.org/debian bullseye InRelease                                                      
Hit:4 http://ftp.debian.org/debian bullseye-updates InRelease                
Get:5 https://packages.microsoft.com/repos/azure-cli bullseye InRelease [10.4 kB]
Get:6 https://packages.microsoft.com/repos/azure-cli bullseye/main amd64 Packages [4075 B]
Fetched 14.5 kB in 1s (22.2 kB/s)
Reading package lists... Done


$ apt-get install azure-cli
-------------------------------------------------------------------------------
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  azure-cli
0 upgraded, 1 newly installed, 0 to remove and 53 not upgraded.
Need to get 82.4 MB of archives.
After this operation, 1223 MB of additional disk space will be used.
Get:1 https://packages.microsoft.com/repos/azure-cli bullseye/main amd64 azure-cli all 2.43.0-1~bullseye [82.4 MB]
Fetched 82.4 MB in 2s (51.5 MB/s)     
Selecting previously unselected package azure-cli.
(Reading database ... 29739 files and directories currently installed.)
Preparing to unpack .../azure-cli_2.43.0-1~bullseye_all.deb ...
Unpacking azure-cli (2.43.0-1~bullseye) ...
Setting up azure-cli (2.43.0-1~bullseye) ...
```

### Step 2. Login to Azure
```
$ az login --use-device-code

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ******** to authenticate.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "********",
    "id": "********",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "********",
    "user": {
      "name": "********",
      "type": "user"
    }
  }
]

```

### Step 3. Create service principle
Yes, it is needed


### Step 4. Install Terraform
[Official documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
```
# apt-get update && apt-get install -y gnupg software-properties-common
-------------------------------------------------------------------------------
Hit:1 http://security.debian.org bullseye-security InRelease
Hit:2 http://ftp.debian.org/debian bullseye InRelease                                                                              
Get:3 http://ftp.debian.org/debian bullseye-updates InRelease [44.1 kB]                                                            
Hit:4 https://download.docker.com/linux/debian bullseye InRelease                                                                  
Hit:5 https://packages.microsoft.com/repos/azure-cli bullseye InRelease                                                            
!
! OUTPUT IS TRUNCATED FOR BREVITY
!
Processing triggers for man-db (2.9.4-2) ...
Processing triggers for dbus (1.12.24-0+deb11u1) ...


$ wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------------------------------------
--2022-12-14 21:14:25--  https://apt.releases.hashicorp.com/gpg
Resolving apt.releases.hashicorp.com (apt.releases.hashicorp.com)... 18.244.179.53, 18.244.179.62, 18.244.179.43, ...
Connecting to apt.releases.hashicorp.com (apt.releases.hashicorp.com)|18.244.179.53|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3195 (3.1K) [binary/octet-stream]
Saving to: 'STDOUT'

-                                                   100%[=================================================================================================================>]   3.12K  --.-KB/s    in 
!
! OUTPUT IS TRUNCATED FOR BREVITY


$ gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
-------------------------------------------------------------------------------
gpg: directory '/root/.gnupg' created
gpg: /root/.gnupg/trustdb.gpg: trustdb created
/usr/share/keyrings/hashicorp-archive-keyring.gpg
-------------------------------------------------
pub   rsa4096 2020-05-07 [SC]
      E8A0 32E0 94D8 EB4E A189  D270 DA41 8C88 A321 9F7B
uid           [ unknown] HashiCorp Security (HashiCorp Package Signing) <security+packaging@hashicorp.com>
sub   rsa4096 2020-05-07 [E]


$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
-------------------------------------------------------------------------------
deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]     https://apt.releases.hashicorp.com bullseye main


$ apt-get update
-------------------------------------------------------------------------------
Hit:1 http://ftp.debian.org/debian bullseye InRelease
Hit:2 http://ftp.debian.org/debian bullseye-updates InRelease  
Hit:3 http://security.debian.org bullseye-security InRelease   
Hit:4 https://download.docker.com/linux/debian bullseye InRelease                              
Get:5 https://apt.releases.hashicorp.com bullseye InRelease [12.0 kB]                          
Hit:6 https://packages.microsoft.com/repos/azure-cli bullseye InRelease         
Get:7 https://apt.releases.hashicorp.com bullseye/main amd64 Packages [74.0 kB]
Fetched 86.1 kB in 1s (117 kB/s)   
Reading package lists... Done


$ apt-get install terraform -y
-------------------------------------------------------------------------------
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 53 not upgraded.
Need to get 19.5 MB of archives.
After this operation, 61.3 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com bullseye/main amd64 terraform amd64 1.3.6 [19.5 MB]
Fetched 19.5 MB in 0s (58.2 MB/s)
Selecting previously unselected package terraform.
(Reading database ... 83752 files and directories currently installed.)
Preparing to unpack .../terraform_1.3.6_amd64.deb ...
Unpacking terraform (1.3.6) ...
Setting up terraform (1.3.6) ...
```

Check installed version:
```
$ terraform version
-------------------------------------------------------------------------------
Terraform v1.3.6
on linux_amd64
```

### Step 5. Prepare Terraform files for provisioning Kubernetes cluster in AKS
[Azure example](https://learn.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks)
Create files:
- providers.tf
- main.tf
- variables.tf
- outputs.tf
- terraform.tfvars

Additionally, we need ssh keys:
- ssh-prv.key
- ssh-pub.key

### Step 6. Deploy K8s cluster on
Create workspace:
```
$ terraform workspace new k8s-1
-------------------------------------------------------------------------------
Created and switched to workspace "k8s-1"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.


$ terraform workspace list
-------------------------------------------------------------------------------
  default
* k8s-1
```

Install providers:
```
$ terraform init
-------------------------------------------------------------------------------
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/random versions matching "~> 3.0"...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/random v3.4.3...
- Installed hashicorp/random v3.4.3 (signed by HashiCorp)
- Installing hashicorp/azurerm v3.35.0...
- Installed hashicorp/azurerm v3.35.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Plan deployment:
```
$ terraform plan -var-file terraform.tfvars 
-------------------------------------------------------------------------------
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.k8s will be created
  + resource "azurerm_kubernetes_cluster" "k8s" {
      + automatic_channel_upgrade           = "patch"
      + dns_prefix                          = "k8s-on-aks"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + image_cleaner_enabled               = false
      + image_cleaner_interval_hours        = 48
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "eastus"
      + name                                = "k8s-on-aks"
      + node_resource_group                 = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "karneliuk-rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + tags                                = {
          + "Environment" = "Development"
        }
      + workload_identity_enabled           = false

      + auto_scaler_profile {
          + balance_similar_node_groups      = (known after apply)
          + empty_bulk_delete_max            = (known after apply)
          + expander                         = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + max_node_provisioning_time       = (known after apply)
          + max_unready_nodes                = (known after apply)
          + max_unready_percentage           = (known after apply)
          + new_pod_scale_up_delay           = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
          + skip_nodes_with_local_storage    = (known after apply)
          + skip_nodes_with_system_pods      = (known after apply)
        }

      + default_node_pool {
          + kubelet_disk_type    = (known after apply)
          + max_pods             = (known after apply)
          + name                 = "k8snodepool"
          + node_count           = 1
          + node_labels          = (known after apply)
          + orchestrator_version = (known after apply)
          + os_disk_size_gb      = (known after apply)
          + os_disk_type         = "Managed"
          + os_sku               = (known after apply)
          + scale_down_mode      = "Delete"
          + type                 = "VirtualMachineScaleSets"
          + ultra_ssd_enabled    = false
          + vm_size              = "Standard_B4ms"
          + workload_runtime     = (known after apply)
        }

      + kubelet_identity {
          + client_id                 = (known after apply)
          + object_id                 = (known after apply)
          + user_assigned_identity_id = (known after apply)
        }

      + linux_profile {
          + admin_username = "admin-user"

          + ssh_key {
              + key_data = "ssh-rsa ****"
            }
        }

      + network_profile {
          + dns_service_ip     = (known after apply)
          + docker_bridge_cidr = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_mode       = (known after apply)
          + network_plugin     = "kubenet"
          + network_policy     = (known after apply)
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile {
              + effective_outbound_ips      = (known after apply)
              + idle_timeout_in_minutes     = (known after apply)
              + managed_outbound_ip_count   = (known after apply)
              + managed_outbound_ipv6_count = (known after apply)
              + outbound_ip_address_ids     = (known after apply)
              + outbound_ip_prefix_ids      = (known after apply)
              + outbound_ports_allocated    = (known after apply)
            }

          + nat_gateway_profile {
              + effective_outbound_ips    = (known after apply)
              + idle_timeout_in_minutes   = (known after apply)
              + managed_outbound_ip_count = (known after apply)
            }
        }

      + service_principal {
          + client_id     = "********"
          + client_secret = (sensitive value)
        }

      + windows_profile {
          + admin_password = (sensitive value)
          + admin_username = (known after apply)
          + license        = (known after apply)

          + gmsa {
              + dns_server  = (known after apply)
              + root_domain = (known after apply)
            }
        }
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "karneliuk-rg"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + client_certificate     = (sensitive value)
  + client_key             = (sensitive value)
  + cluster_ca_certificate = (sensitive value)
  + cluster_password       = (sensitive value)
  + cluster_username       = (sensitive value)
  + host                   = (sensitive value)
  + kube_config            = (sensitive value)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Deploy it:
```
$ terraform apply -var-file terraform.tfvars 
-------------------------------------------------------------------------------
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.k8s will be created
  + resource "azurerm_kubernetes_cluster" "k8s" {
      + automatic_channel_upgrade           = "patch"
      + dns_prefix                          = "k8s-on-aks"
      + fqdn                                = (known after apply)
      + http_application_routing_zone_name  = (known after apply)
      + id                                  = (known after apply)
      + image_cleaner_enabled               = false
      + image_cleaner_interval_hours        = 48
      + kube_admin_config                   = (sensitive value)
      + kube_admin_config_raw               = (sensitive value)
      + kube_config                         = (sensitive value)
      + kube_config_raw                     = (sensitive value)
      + kubernetes_version                  = (known after apply)
      + location                            = "eastus"
      + name                                = "k8s-on-aks"
      + node_resource_group                 = (known after apply)
      + oidc_issuer_url                     = (known after apply)
      + portal_fqdn                         = (known after apply)
      + private_cluster_enabled             = false
      + private_cluster_public_fqdn_enabled = false
      + private_dns_zone_id                 = (known after apply)
      + private_fqdn                        = (known after apply)
      + public_network_access_enabled       = true
      + resource_group_name                 = "karneliuk-rg"
      + role_based_access_control_enabled   = true
      + run_command_enabled                 = true
      + sku_tier                            = "Free"
      + tags                                = {
          + "Environment" = "Development"
        }
      + workload_identity_enabled           = false

      + auto_scaler_profile {
          + balance_similar_node_groups      = (known after apply)
          + empty_bulk_delete_max            = (known after apply)
          + expander                         = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + max_node_provisioning_time       = (known after apply)
          + max_unready_nodes                = (known after apply)
          + max_unready_percentage           = (known after apply)
          + new_pod_scale_up_delay           = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
          + skip_nodes_with_local_storage    = (known after apply)
          + skip_nodes_with_system_pods      = (known after apply)
        }

      + default_node_pool {
          + kubelet_disk_type    = (known after apply)
          + max_pods             = (known after apply)
          + name                 = "k8snodepool"
          + node_count           = 1
          + node_labels          = (known after apply)
          + orchestrator_version = (known after apply)
          + os_disk_size_gb      = (known after apply)
          + os_disk_type         = "Managed"
          + os_sku               = (known after apply)
          + scale_down_mode      = "Delete"
          + type                 = "VirtualMachineScaleSets"
          + ultra_ssd_enabled    = false
          + vm_size              = "Standard_B4ms"
          + workload_runtime     = (known after apply)
        }

      + kubelet_identity {
          + client_id                 = (known after apply)
          + object_id                 = (known after apply)
          + user_assigned_identity_id = (known after apply)
        }

      + linux_profile {
          + admin_username = "admin-user"

          + ssh_key {
              + key_data = "ssh-rsa *********"
            }
        }

      + network_profile {
          + dns_service_ip     = (known after apply)
          + docker_bridge_cidr = (known after apply)
          + ip_versions        = (known after apply)
          + load_balancer_sku  = "standard"
          + network_mode       = (known after apply)
          + network_plugin     = "kubenet"
          + network_policy     = (known after apply)
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + pod_cidrs          = (known after apply)
          + service_cidr       = (known after apply)
          + service_cidrs      = (known after apply)

          + load_balancer_profile {
              + effective_outbound_ips      = (known after apply)
              + idle_timeout_in_minutes     = (known after apply)
              + managed_outbound_ip_count   = (known after apply)
              + managed_outbound_ipv6_count = (known after apply)
              + outbound_ip_address_ids     = (known after apply)
              + outbound_ip_prefix_ids      = (known after apply)
              + outbound_ports_allocated    = (known after apply)
            }

          + nat_gateway_profile {
              + effective_outbound_ips    = (known after apply)
              + idle_timeout_in_minutes   = (known after apply)
              + managed_outbound_ip_count = (known after apply)
            }
        }

      + service_principal {
          + client_id     = "*****"
          + client_secret = (sensitive value)
        }

      + windows_profile {
          + admin_password = (sensitive value)
          + admin_username = (known after apply)
          + license        = (known after apply)

          + gmsa {
              + dns_server  = (known after apply)
              + root_domain = (known after apply)
            }
        }
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "karneliuk-rg"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + client_certificate     = (sensitive value)
  + client_key             = (sensitive value)
  + cluster_ca_certificate = (sensitive value)
  + cluster_password       = (sensitive value)
  + cluster_username       = (sensitive value)
  + host                   = (sensitive value)
  + kube_config            = (sensitive value)

Do you want to perform these actions in workspace "k8s-1"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 1s [id=/subscriptions/********************/resourceGroups/giga-rg]
azurerm_kubernetes_cluster.k8s: Creating...
azurerm_kubernetes_cluster.k8s: Still creating... [10s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [20s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [30s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [40s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [50s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m0s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m10s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m20s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m30s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m40s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [1m50s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m0s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m10s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m20s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m30s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m40s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [2m50s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [3m0s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [3m10s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [3m20s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [3m30s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [3m40s elapsed]
azurerm_kubernetes_cluster.k8s: Creation complete after 3m47s [id=/subscriptions/********************/resourceGroups/giga-rg/providers/Microsoft.ContainerService/managedClusters/k8s-on-aks]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

client_certificate = <sensitive>
client_key = <sensitive>
cluster_ca_certificate = <sensitive>
cluster_password = <sensitive>
cluster_username = <sensitive>
host = <sensitive>
kube_config = <sensitive>
```

Generate kubeconfig file:
```
$ echo "$(terraform output kube_config)" > ./azurek8s.yaml
```

### Step 7. Install kubectl
[Official documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
```
$ apt-get install -y ca-certificates curl apt-transport-https
-------------------------------------------------------------------------------
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
apt-transport-https is already the newest version (2.2.4).
ca-certificates is already the newest version (20210119).
curl is already the newest version (7.74.0-1.3+deb11u3).
0 upgraded, 0 newly installed, 0 to remove and 53 not upgraded.


$ curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg


$ echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
-------------------------------------------------------------------------------
deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main
root@self-pod-999-ah:~/aks# apt-get update
Hit:1 http://security.debian.org bullseye-security InRelease
Hit:2 http://ftp.debian.org/debian bullseye InRelease                                       
Hit:3 http://ftp.debian.org/debian bullseye-updates InRelease                                                                                                                               
Hit:4 https://download.docker.com/linux/debian bullseye InRelease                                                                                                                           
Hit:5 https://apt.releases.hashicorp.com bullseye InRelease                                                                                                           
Hit:6 https://packages.microsoft.com/repos/azure-cli bullseye InRelease                                          
Get:7 https://packages.cloud.google.com/apt kubernetes-xenial InRelease [9383 B]         
Get:8 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 Packages [62.2 kB]
Fetched 71.6 kB in 1s (75.3 kB/s)   
Reading package lists... Done


$ apt-get install -y kubectl
-------------------------------------------------------------------------------
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  kubectl
0 upgraded, 1 newly installed, 0 to remove and 53 not upgraded.
Need to get 10.1 MB of archives.
After this operation, 48.0 MB of additional disk space will be used.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.26.0-00 [10.1 MB]
Fetched 10.1 MB in 0s (24.8 MB/s)
apt-listchanges: Can't set locale; make sure $LC_* and $LANG are correct!
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = (unset),
        LC_ALL = (unset),
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
Selecting previously unselected package kubectl.
(Reading database ... 83755 files and directories currently installed.)
Preparing to unpack .../kubectl_1.26.0-00_amd64.deb ...
Unpacking kubectl (1.26.0-00) ...
Setting up kubectl (1.26.0-00) .
```

### Step 8. Connect to K8s on AKS
change path to kubeconfig:
```
$ export KUBECONFIG=./azurek8s.yaml
```

Interact with Kubernetes cluster:
```
$ kubectl get nodes
-------------------------------------------------------------------------------
NAME                                  STATUS   ROLES   AGE     VERSION
aks-k8snodepool-24388181-vmss000000   Ready    agent   3m32s   v1.24.6


$ kubectl top nodes
-------------------------------------------------------------------------------
NAME                                  CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
aks-k8snodepool-24388181-vmss000000   93m          2%     1018Mi          8% 
```

### Step 9. Deploy app
**Need to create LimitRange**
```
$ kubectl create namespace test-app
-------------------------------------------------------------------------------
namespace/test-app created


$ kubectl create -n test-app deployment test-web --image nginx:1.22 --replicas 2 --dry-run=client -o yaml > k8s/deployment.yaml


$ kubectl apply -f k8s/deployment.yaml
-------------------------------------------------------------------------------
deployment.apps/test-web created


$ kubectl -n test-app expose deployment test-web --type ClusterIP --port 80 --target-port 80 --name svc-4-test-web --dry-run=client -o yaml > k8s/service.yaml


$ kubectl apply -f k8s/service.yaml
-------------------------------------------------------------------------------
service/svc-4-test-web created
```

Validate setup:
```
$ kubectl -n test-app get deployments.apps
-------------------------------------------------------------------------------
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
test-web   2/2     2            2           13s


$ kubectl -n test-app get pods
-------------------------------------------------------------------------------     
NAME                        READY   STATUS    RESTARTS   AGE
test-web-7c4847d74b-5949f   1/1     Running   0          17s
test-web-7c4847d74b-lxwjn   1/1     Running   0          17s


$ kubectl -n test-app get services
-------------------------------------------------------------------------------
NAME             TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)          AGE
svc-4-test-web   LoadBalancer   10.0.190.75   -               80/TCP           43s
```

Test app:
```
$ curl http://20.242.164.74:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```