cd ../challenge-day2/frontend
echo "VITE_API_BASE_URL=http://a0b960d9616fa4b7294cc9126748d484-521357833.us-east-1.elb.amazonaws.com:5000/api" > .env
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/o7s4h9d1/cloudmart/frontend
docker build -t cloudmart-frontend .
docker tag cloudmart-frontend:latest public.ecr.aws/o7s4h9d1/cloudmart/frontend:latest
docker push public.ecr.aws/o7s4h9d1/cloudmart/frontend:latest
echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloudmart-frontend-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cloudmart-frontend-app
  template:
    metadata:
      labels:
        app: cloudmart-frontend-app
    spec:
      serviceAccountName: cloudmart-pod-execution-role
      containers:
      - name: cloudmart-frontend-app
        image: public.ecr.aws/o7s4h9d1/cloudmart/frontend:latest
---

apiVersion: v1
kind: Service
metadata:
  name: cloudmart-frontend-app-service
spec:
  type: LoadBalancer
  selector:
    app: cloudmart-frontend-app
  ports:
    - protocol: TCP
      port: 5001
      targetPort: 5001" > cloudmart-frontend.yaml
kubectl apply -f cloudmart-frontend.yaml
kubectl get pods
kubectl get deployment
kubectl get service
#apagar
kubectl delete service cloudmart-frontend-app-service
kubectl delete deployment cloudmart-frontend-app