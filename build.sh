#!/bin/bash
current_date=`date +%s`
sed -r "s/\"built_at\": [0-9]{10}/\"built_at\": $current_date/g" index.html >tmp;mv tmp index.html
#Setting  up  minikube docker env, to deploy this image in the next step
minikube start
if [ $? == 0 ]; then
    echo "Minikube started successfully"
    eval $(minikube -p minikube docker-env)
    docker build -t myapp -f Dockerfile .
    if [ $? == 0 ]; then
        echo "Build is successful"
    else
        echo "Build Failed"
    fi
else
    echo "Failed to start Minikube..."
    exit 1
fi