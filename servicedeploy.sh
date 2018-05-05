#!/bin/bash
echo "How many services do you wanna create:"
read NUM

for ((svc=1;svc<$NUM+1;svc=svc+1))
do 
cp service.yaml service$svc.yaml
echo"
kind: Service
apiVersion: v1
metadata:
  labels:
    node: node$svc 
  name: nodesvc$svc
spec:
  selector:
    node: node$svc 
  ports:
  - name: ipc
    port: 2100$svc-1
    targetPort: 2100$svc-1
  - name: raftport
    port: 5040$svc
    targetPort: 5040$svc
  - name: rpcport
    port: 2200$svc-1
    targetPort: 2200$svc-1
  - name: geth
    port: 900$svc
    targetPort: 900$svc
  type: LoadBalancer" > service$svc.yaml

 kubectl create -f service$svc.yaml
 

done