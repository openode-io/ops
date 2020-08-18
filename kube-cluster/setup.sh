
KUBECONFIG=development-canada.yml helm repo add nginx-stable https://helm.nginx.com/stable

KUBECONFIG=development-canada.yml helm install quickstart nginx-stable/nginx-ingress

# to get list of services, column 4 gives cname (subdomains)
# quickstart-nginx-ingress-controller LoadBalancer 10.3.192.240 6ojq4g6ss0.lb.c1.bhs5.k8s.ovh.net   80:31114/TCP,443:30631/TCP   3m42s
KUBECONFIG=development-canada.yml kubectl get services

# PROXY PROTOCOL

# Configure the NGINX configmap for proxy-protocol
# kubectl edit configmap quickstart-nginx-ingress
#data:
#  proxy-protocol: "True"
#  real-ip-header: proxy_protocol
#  set-real-ip-from: 10.136.75.230 # <--- this is the IP obtained when not using this option

# # and enable the proxy protocol
# kubectl annotate service quickstart-nginx-ingress service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol=true