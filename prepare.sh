

aws s3api create-bucket --bucket mirdan-k8s-kops --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
aws s3api put-bucket-versioning --region eu-west-1 --bucket mirdan-k8s-kops --versioning-configuration Status=Enabled
aws s3 ls

aws route53 create-hosted-zone --name tftest.mirdanhost.internal --caller-reference 1
aws route53 create-hosted-zone --name mirdanhost.internal --caller-reference 1

#!/bin/bash
 
# Source our aws environment
[[ -f ~/ec2/aws.conf ]] && . ~/ec2/aws.conf
 
export NAME="tftest.mirdanhost.internal" 
export KOPS_STATE_STORE="s3://mirdan-k8s-kops"
#export KOPS_FEATURE_FLAGS="+UseLegacyELBName"
#export KOPS_FEATURE_FLAGS="+DrainAndValidateRollingUpdate"
export VPC_ID="vpc-xxxxxxxx"
export NETWORK_CIDR="10.99.0.0/20"
export ZONES="eu-west-1a,eu-west-1b,eu-west-1c"
export SSH_PUBLIC_KEY="~/ec2/.ssh/ec2key-pub.pem"
export ADMIN_ACCESS="[10.99.0.0/20,210.10.195.106/32,123.243.200.245/32]"
export DNS_ZONE_PRIVATE_ID="Z1XMCUO9OK9E2D"
export DNS_ZONE_ID="Z1XMCUO9OK9E2D"
export NODE_SIZE="t2.medium"
export NODE_COUNT=3
export MASTER_SIZE="t2.small"
export KUBERNETES_VERSION="1.11.10"
kops create cluster \
    --name "${NAME}" \
    --cloud aws \
    --kubernetes-version ${KUBERNETES_VERSION} \
    --cloud-labels "Environment=\"tftest\",Type=\"k8s\",Role=\"node\",Provisioner=\"kops\"" \
    --node-count ${NODE_COUNT} \
    --zones "${ZONES}" \
    --master-zones "${ZONES}" \
    --node-size "${NODE_SIZE}" \
    --master-size "${MASTER_SIZE}" \
    --topology private \
    --network-cidr "${NETWORK_CIDR}" \
    --networking calico 


    --dns private \
    --dns-zone "${DNS_ZONE_PRIVATE_ID}" \
    --admin-access "${ADMIN_ACCESS}" \
    --vpc "${VPC_ID}" \
    --ssh-public-key ${SSH_PUBLIC_KEY}

    
kops edit cluster tftest.mirdanhost.internal

kops update cluster --name=tftest.mirdanhost.internal --yes

kops update cluster --config kops-deployment.yaml --name=tftest.mirdanhost.internal --yes

kops validate cluster --name=tftest.mirdanhost.internal



kops create cluster --config kops-deployment.yaml --name=tftest.mirdanhost.internal


kops create -f kops-deployment.yaml







note: last error

W1218 02:06:49.971316   20359 executor.go:130] error running task "DNSZone/Z1XMCUO9OK9E2D" (7m14s remaining to succeed): error associating VPC with hosted zone "tftest.mirdanhost.internal": PublicZoneVPCAssociation: Attempting to associate public zone: Z1XMCUO9OK9E2D with vpc: vpc-0355a384e95ca034a
        status code: 400, request id: b8b2c52c-283f-40cc-a685-dc390fc7ed7a
I1218 02:06:49.971415   20359 executor.go:103] Tasks: 115 done / 119 total; 1 can run
W1218 02:07:12.365635   20359 executor.go:130] error running task "DNSZone/Z1XMCUO9OK9E2D" (6m52s remaining to succeed): error associating VPC with hosted zone "tftest.mirdanhost.internal": PublicZoneVPCAssociation: Attempting to associate public zone: Z1XMCUO9OK9E2D with vpc: vpc-0355a384e95ca034a
        status code: 400, request id: 467df810-cfde-4804-92fb-9bbffe3508c1
I1218 02:07:12.365706   20359 executor.go:145] No progress made, sleeping before retrying 1 failed task(s)
I1218 02:07:22.369126   20359 executor.go:103] Tasks: 115 done / 119 total; 1 can run
W1218 02:07:44.930902   20359 executor.go:130] error running task "DNSZone/Z1XMCUO9OK9E2D" (6m19s remaining to succeed): error associating VPC with hosted zone "tftest.mirdanhost.internal": PublicZoneVPCAssociation: Attempting to associate public zone: Z1XMCUO9OK9E2D with vpc: vpc-0355a384e95ca034a
        status code: 400, request id: 6677287f-f11a-48b2-a5ba-3237e2efecf8
I1218 02:07:44.930969   20359 executor.go:145] No progress made, sleeping before retrying 1 failed task(s)
I1218 02:07:54.936076   20359 executor.go:103] Tasks: 115 done / 119 total; 1 can run