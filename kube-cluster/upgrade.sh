
KUBECONFIG=development-canada.yml helm repo update

KUBECONFIG=development-canada.yml helm delete quickstart

KUBECONFIG=development-canada.yml helm install quickstart nginx-stable/nginx-ingress

# make sure to check proxy protocol, option set-real-ip-from, see setup.sh