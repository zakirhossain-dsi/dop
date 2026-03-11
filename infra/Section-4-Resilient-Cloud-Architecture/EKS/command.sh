aws eks update-kubeconfig \
--region ap-southeast-1 \
--profile terraform-admin \
--name demo-eks-cluster

kubectl get svc
kubectl get nodes
kubectl run nginx --image=nginx
kubectl get pods