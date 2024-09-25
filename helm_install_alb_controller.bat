@echo off

helm install aws-load-balancer-controller eks/aws-load-balancer-controller ^
  -n kube-system ^
  --set clusterName=obi-dev-cluster ^
  --set serviceAccount.create=false ^
  --set serviceAccount.name=aws-load-balancer-controller ^
  --set region=eu-central-1 ^
  --set vpcId=vpc-vpc-062a759db39eec6c3




