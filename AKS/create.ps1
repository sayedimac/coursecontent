######################
# Create AKS CLuster #
######################
# Create a new AKS cluster in the Free tier
az aks create --resource-group myResourceGroup --name myAKSCluster --tier free

# Create a new AKS cluster in the Standard tier
az aks create --resource-group myResourceGroup --name myAKSCluster --tier standard

# Create a new AKS cluster in the Premium tier
# LongTermSupport and Premium tier should be enabled/disabled together

az aks create --resource-group myResourceGroup --name myAKSCluster --tier premium --k8s-support-plan AKSLongTermSupport


#######################
# Upgrade AKS CLuster #
#######################

# Update an existing cluster to the Premium tier
az aks update --resource-group myResourceGroup --name myAKSCluster --tier premium --k8s-support-plan AKSLongTermSupport

# Update an existing cluster to from Premium tier to Free or Standard tier
az aks update --resource-group myResourceGroup --name myAKSCluster --tier free --k8s-support-plan KubernetesOfficial