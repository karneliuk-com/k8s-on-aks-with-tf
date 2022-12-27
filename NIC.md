# NGINX Ingress Controller

## Steps
### Step 1. Install Helm
```
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
-------------------------------------------------------------------------------
Downloading https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

Check if it is installed:
```
$ helm version
-------------------------------------------------------------------------------
version.BuildInfo{Version:"v3.10.3", GitCommit:"835b7334cfe2e5e27870ab3ed4135f136eecc704", GitTreeState:"clean", GoVersion:"go1.18.9"}
```

### Step 2. Install NGINX Ingress Controller
```
$ helm repo add nginx-stable https://helm.nginx.com/stable
-------------------------------------------------------------------------------
"nginx-stable" has been added to your repositories


$ helm repo update
-------------------------------------------------------------------------------
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "nginx-stable" chart repository


$ helm search repo ingress 
-------------------------------------------------------------------------------
NAME                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
nginx-stable/nginx-ingress              0.15.2          2.4.2           NGINX Ingress Controller  


$  kubectl create namespace nginx-ingress
-------------------------------------------------------------------------------
namespace/nginx-ingress created


$ helm -n nginx-ingress install nic-non-plus nginx-stable/nginx-ingress
-------------------------------------------------------------------------------
NAME: nic-non-plus
LAST DEPLOYED: Mon Dec 19 22:12:43 2022
NAMESPACE: nginx-ingress
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NGINX Ingress Controller has been installed.
```

### Step 3. Use NGINX Ingress Controller
Check that the NGINX Ingress Controller is installed:
```
$ kubectl -n nginx-ingress get deployments.apps,pods,services    
-------------------------------------------------------------------------------
NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nic-non-plus-nginx-ingress   1/1     1            1           54s

NAME                                            READY   STATUS    RESTARTS   AGE
pod/nic-non-plus-nginx-ingress-57d946bd-5vcn4   1/1     Running   0          54s

NAME                                 TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)                      AGE
service/nic-non-plus-nginx-ingress   LoadBalancer   10.0.39.148   40.88.234.198   80:32081/TCP,443:32720/TCP   55s


$ kubectl get ingressclass
-------------------------------------------------------------------------------
NAME    CONTROLLER                     PARAMETERS   AGE
nginx   nginx.org/ingress-controller   <none>       2m1s
```

Create Ingress for the service:
```
$ tee ingress.yaml << __EOF__
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-app-ingress
  namespace: test-app
spec:
  ingressClassName: nginx
  rules:
    - host: aks.karneliuk.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: svc-4-test-web
                port:
                  number: 80
__EOF__


$ kubectl apply -f ingress.yaml
-------------------------------------------------------------------------------
ingress.networking.k8s.io/test-app-ingress created
```

Check operational status:
```
# kubectl -n test-app describe ingress test-app-ingress
-------------------------------------------------------------------------------
Name:             test-app-ingress
Labels:           <none>
Namespace:        test-app
Address:          40.88.234.198
Ingress Class:    nginx
Default backend:  <default>
Rules:
  Host              Path  Backends
  ----              ----  --------
  aks.karneliuk.com  
                    /   svc-4-test-web:80 (10.244.0.15:80,10.244.0.16:80)
Annotations:        <none>
Events:
  Type    Reason          Age   From                      Message
  ----    ------          ----  ----                      -------
  Normal  AddedOrUpdated  49s   nginx-ingress-controller  Configuration for test-app/test-app-ingress was added or updated
```

Access the site:
```
$ curl http://40.88.234.198 -H "Host: aks.karneliuk.com"
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```