#!/bin/bash
echo "How many services do you want to create "
read NUM

for ((svc=1;svc<$NUM+1;$NUM=$NUM+1))
do 
	cp service.yaml service$svc.yaml


done