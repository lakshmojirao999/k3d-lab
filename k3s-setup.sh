for node in k3smaster k3snode1 k3snode2;do
  multipass launch -n $node
done
# Init cluster on node1
multipass exec k3smaster -- bash -c "curl -sfL https://get.k3s.io | sh -"

# Get node1's IP
IP=$(multipass info k3smaster | grep IPv4 | awk '{print $2}')

# Get Token used to join nodes
TOKEN=$(multipass exec k3smaster sudo cat /var/lib/rancher/k3s/server/node-token)

# Join node2
multipass exec k3snode1 -- \
bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"

# Join node3
multipass exec k3snode2 -- \
bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"

# Get cluster's configuration
multipass exec k3smaster sudo cat /etc/rancher/k3s/k3s.yaml > k3s.yaml

# Set node1's external IP in the configuration file
sed -i '' "s/127.0.0.1/$IP/" k3s.yaml

# We'r all set
echo
echo "K3s cluster is ready !"
echo
echo "Run the following command to set the current context:"
echo "$ export KUBECONFIG=$PWD/k3s.yaml"
echo
echo "and start to use the cluster:"
echo  "$ kubectl get nodes"
echo