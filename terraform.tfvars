# Environment-specific values

resource_group_name = "aks-dev-rg1"
location            = "East US"
aks_cluster_name    = "myAKSCluster1"
node_count          = 2
node_size           = "Standard_DS2_v2"
kubernetes_version = "1.32.5"


tags = {
  Environment = "dev"
  Project     = "aks-terraform"
  Owner       = "prathyusha"
  ManagedBy   = "terraform"
}
