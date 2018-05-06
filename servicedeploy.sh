#!/bin/bash
echo "How many services do you wanna create:"
read NUM
export NUM_K8S=$(echo ${NUM})
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
    port: 21000
    targetPort: 21000
  - name: raftport
    port: 50400
    targetPort: 50400
  - name: rpcport
    port: 22000
    targetPort: 22000
  - name: geth
    port: 9000
    targetPort: 9000
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
done
done

sh 7nodeDeploy.sh