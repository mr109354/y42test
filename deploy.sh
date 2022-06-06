#!/bin/bash
minikube start
if [ $? == 0 ]; then
    echo "Minikube started successfully"
else
    echo "Failed to start Minikube..."
    exit 1
fi 
kubectl apply -f deployment.yaml
if [ $? == 0 ]; then
    echo "Deployed the app in Minikube"
    #wait for the pod to start
    sleep 5
else
    echo "Failed to deploy app in Minikube..."
    exit 1;
fi
#Change the deploy time in html file
kubectl exec -it $(kubectl get pods -l app=myapp --no-headers | awk '{print $1}') -- sed -Ei "s/\"deployed_at\": [0-9]{10}/\"deployed_at\": $(date +%s)/g" /var/www/html/index.html
#expose port 80
kubectl expose deployment myapp --port=80 --type=LoadBalancer
echo "Open http://127.0.0.1/ in your browser after opening the minikube tunnel"
#open the minikube tunnel for accessing the website
minikube tunnel
#open the site with the local ip address
open http://127.0.0.1/