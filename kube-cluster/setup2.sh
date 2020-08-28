# with https://github.com/kubernetes/ingress-nginx

KUBECONFIG=development-test.yml helm repo add stable https://kubernetes-charts.storage.googleapis.com/

KUBECONFIG=development-test.yml helm install nginx-ingress stable/nginx-ingress

# Configuring memory for nginx controller (deployment)

KUBECONFIG=development-test.yml kubectl edit deployment nginx-ingress-controller
#resources:
#  requests:
#    memory: 500Mi

# add configmaps, with name corresponding to the one in deployment nginx-ingress-controller
KUBECONFIG=development-test.yml kubectl apply -f ../../../ops/kube-cluster/nginx-configmaps.yml
KUBECONFIG=development-test.yml kubectl annotate service nginx-ingress-controller service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol=true