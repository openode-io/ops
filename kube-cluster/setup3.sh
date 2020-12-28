# with https://github.com/kubernetes/ingress-nginx

KUBECONFIG=development-test.yml helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

KUBECONFIG=development-test.yml helm install nginx-ingress ingress-nginx/ingress-nginx

# Configuring memory for nginx controller (deployment)

KUBECONFIG=development-test.yml kubectl edit deployment nginx-ingress-ingress-nginx-controller
#resources:
#  requests:
#    memory: 500Mi

# strategy:
#   type: Recreate

# add configmaps, with name corresponding to the one in deployment nginx-ingress-controller
KUBECONFIG=development-test.yml kubectl apply -f ../../../ops/kube-cluster/nginx-configmaps.yml

# metrics server
KUBECONFIG=development-test.yml kubectl apply -f ../../../ops/kube-cluster/metrics-server-components.yaml

KUBECONFIG=development-test.yml kubectl annotate service nginx-ingress-ingress-nginx-controller service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol=true
