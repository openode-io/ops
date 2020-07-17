
KUBECONFIG=development-canada.yml helm repo update

KUBECONFIG=development-canada.yml helm delete quickstart

KUBECONFIG=development-canada.yml helm install quickstart nginx-stable/nginx-ingress
