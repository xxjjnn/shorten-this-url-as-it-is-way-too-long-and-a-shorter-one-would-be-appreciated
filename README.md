# README

* Install stuff. I use asdf (instead of rbenv) so get ruby 3.2.1 installed. Bundle install, yarn install etc.

To get it kooberneeted I followed steps to install minikube. Then:

docker build -t shortener .
eval $(minikube docker-env)
kubectl apply -f dat_app.yaml
minikube service shortenerapp --url

that last one tells you the local url where your pod is running
