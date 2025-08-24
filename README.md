# Azure Ubuntu VMs for Kubernetes Cluster Deployment

This Terraform configuration deploys 2 Ubuntu virtual machines on Azure as infrastructure foundation for a Kubernetes cluster setup. The VMs are configured in the same virtual network to enable easy cluster communication and management.

## Features

- 2 Ubuntu VMs (22.04 or 24.04 LTS) ready for Kubernetes cluster deployment
- VMs deployed in the same virtual network for seamless cluster node communication
- SSH access enabled with key-based authentication for secure cluster management
- Network Security Group associated with subnet for centralized security management
- Standard SKU public IP addresses for external access (compatible with Azure Student subscriptions)
- Premium SSD storage for better Kubernetes performance and faster container operations
- VM specifications suitable for master and worker node configurations

## Prerequisites

1. **Azure CLI** - Install and configure Azure CLI
   ```bash
   az login
   ```

2. **Terraform** - Install Terraform (version 1.0+)

3. **SSH Key Pair** - Generate SSH key pair if you don't have one
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
   ```

## Configuration

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` to customize your deployment:
   - `resource_group_name`: Name for the Azure resource group
   - `location`: Azure region (e.g., "East US", "West Europe")
   - `prefix`: Prefix for resource names
   - `vm_size`: VM size (Standard_B2s for testing, Standard_D2s_v3 for production Kubernetes clusters)
   - `admin_username`: Username for VM access
   - `ssh_public_key_path`: Path to your SSH public key file
   - `ubuntu_version`: Choose between "22.04" or "24.04" (both support Kubernetes)
   - `environment`: Environment tag

## Deployment

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the deployment plan:
   ```bash
   terraform plan
   ```

3. Deploy the infrastructure:
   ```bash
   terraform apply
   ```

4. Confirm the deployment by typing `yes` when prompted.

## Accessing VMs for Kubernetes Setup

After deployment, you can SSH into the VMs to begin Kubernetes installation:

```bash
# VM1 (can be configured as Kubernetes master node)
ssh azureuser@<VM1_PUBLIC_IP>

# VM2 (can be configured as Kubernetes worker node)
ssh azureuser@<VM2_PUBLIC_IP>
```

The VMs can communicate with each other using their private IP addresses, which is essential for Kubernetes cluster networking.

## Network Configuration

- **Virtual Network**: 10.0.0.0/16
- **Subnet**: 10.0.2.0/24 (internal)
- **Security Group**: Associated with subnet, allows SSH (port 22) from any source
- **Public IPs**: Standard SKU with static allocation for both VMs

## VM Communication for Kubernetes

Both VMs are in the same subnet and can communicate with each other using:
- Private IP addresses (shown in Terraform outputs) - essential for Kubernetes API server communication
- VM names (after configuring DNS or hosts file)
- Kubernetes networking will leverage this existing network infrastructure

## Next Steps - Kubernetes Installation

After the VMs are deployed, you can proceed with Kubernetes installation:

1. **Install Container Runtime** (Docker/containerd) on both VMs
2. **Install Kubernetes components** (kubeadm, kubelet, kubectl) on both VMs
3. **Initialize Kubernetes cluster** on VM1 (master node)
4. **Join VM2 to the cluster** as a worker node
5. **Configure networking** (CNI plugin like Calico or Flannel)

Example commands for each VM:
```bash
# Update system and install Docker
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io
sudo systemctl enable docker

# Install Kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubeadm kubelet kubectl
```

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

## Cost Considerations

- Standard_B2s VMs are cost-effective for testing/development Kubernetes clusters
- For production Kubernetes clusters, consider Standard_D2s_v3 or larger for better performance
- Premium SSD storage provides better performance for etcd and container operations
- Consider Standard HDD for cost savings if this is a learning/development cluster
- Standard SKU public IPs may have slightly higher cost than Basic SKU but provide better performance and reliability
- Don't forget to destroy resources when not needed to avoid ongoing charges

## Customization

You can modify the configuration by:
- Changing VM sizes in `variables.tf`
- Adding more VMs by duplicating the VM resources
- Modifying network security rules
- Adding data disks or other Azure resources

## Troubleshooting

1. **SSH Key Issues**: Ensure your SSH public key path is correct and the key exists
2. **Azure Authentication**: Make sure you're logged in with `az login`
3. **Resource Naming**: Azure resource names must be unique in some cases
4. **Region Availability**: Some VM sizes might not be available in all regions
5. **Azure Student Subscription**: If you get "IPv4BasicSkuPublicIpCountLimitReached" error, this configuration uses Standard SKU public IPs which are compatible with Azure Student subscriptions
6. **Public IP Allocation**: Standard SKU public IPs use static allocation and provide better performance and availability zone support

## Azure Student Subscription Notes

This configuration is optimized for Azure Student subscriptions and Kubernetes learning:
- Uses Standard SKU public IPs (Basic SKU has restrictions in student subscriptions)
- Static IP allocation ensures consistent connectivity for cluster operations
- Cost-effective VM sizes suitable for learning Kubernetes concepts and development
- Network configuration supports Kubernetes cluster networking requirements
