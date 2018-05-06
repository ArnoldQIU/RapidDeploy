#!/bin/bash
echo "How many services do you wanna create:"
read NUM

for ((svc=1;svc<$NUM+1;svc=svc+1))
do 
echo "kind: Service
apiVersion: v1
metadata:
  labels:
    node: node${svc} 
  name: nodesvc${svc}
spec:
  selector:
    node: node${svc} 
  ports:
  - name: ipc
    port: 2100${svc-1}
    targetPort: 2100${svc-1}
  - name: raftport
    port: 5040${svc}
    targetPort: 5040${svc}
  - name: rpcport
    port: 2200${svc-1}
    targetPort: 2200${svc-1}
  - name: geth
    port: 900${svc}
    targetPort: 900${svc}
  type: LoadBalancer" > service${svc}.yaml

 kubectl apply -f service${svc}.yaml
 done

sleep 1
for ((a=1;a<$NUM+1;a=a+1))
do 
TEMP=$(kubectl get svc nodesvc$a | awk 'NR>1 {print $4}')
while [[ $TEMP = "<pending>" ]]; do
	#statements
	TEMP=$(kubectl get svc nodesvc$a | awk 'NR>1 {print $4}')
	echo 'waiting for service ip....'
	sleep 5
	export SERVICE_IP$a=$(kubectl get svc nodesvc$a | awk 'NR>1 {print $4}')
done
done