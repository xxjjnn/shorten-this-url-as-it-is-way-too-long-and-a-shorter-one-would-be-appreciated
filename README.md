# README

* Install stuff. I use asdf (instead of rbenv) so get ruby 3.2.1 installed. Bundle install, yarn install etc.

To get it kooberneeted I followed steps to install minikube. Then:

    docker build -t shortener .
    eval $(minikube docker-env)
    kubectl apply -f dat_app.yaml
    minikube service shortenerapp --url

that last one tells you the local url where your pod is running

Here's the steps I used to get it on AWS, my aws account id is 512...etc, you need to change dat_app.yaml to point at yours and change the id in the below.

    eksctl create cluster --name shortener-cluster --version 1.26 --region eu-west-2 --nodes 1
    aws ecr create-repository --repository-name shortener
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 512182977566.dkr.ecr.eu-west-2.amazonaws.com
    docker tag shortener:latest 512182977566.dkr.ecr.eu-west-2.amazonaws.com/shortener:latest
    docker push 512182977566.dkr.ecr.eu-west-2.amazonaws.com/shortener:latest
    kubectl apply -f dat_app.yaml
    kubectl get svc

