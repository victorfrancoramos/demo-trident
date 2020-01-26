#!/bin/bash

clear
echo "[root@rhel3 ~]# kubectl create namespace web"
kubectl create namespace web
echo ""
echo "[root@rhel3 ~]# cat k8s_files/web-content-prod.yaml"
cat k8s_files/web-content-prod.yaml
read -p "Press any key to continue... " -n1 -s
clear

echo "[root@rhel3 ~]# tridentctl import volume BackendForNAS web_content -f k8s_files/web-content-prod.yaml -n trident"
tridentctl import volume BackendForNAS web_content -f k8s_files/web-content-prod.yaml -n trident
echo ""
echo "[root@rhel3 ~]# kubectl get pvc -n web"
kubectl get pvc -n web
echo ""
echo "[root@rhel3 ~]# kubectl get pv"
kubectl get pv
read -p "Press any key to continue... " -n1 -s
clear

echo "[root@rhel3 ~]# cat k8s_files/web-prod.yaml"
cat k8s_files/web-prod.yaml
read -p "Press any key to continue... " -n1 -s
clear

echo "[root@rhel3 ~]# kubectl apply -f k8s_files/web-prod.yaml -n web"
kubectl apply -f k8s_files/web-prod.yaml -n web
echo "[root@rhel3 ~]# kubectl get all -n web"
kubectl get all -n web
read -p "Press any key to continue... " -n1 -s

echo "# Copying the volume name"

echo "(echo -n \"trident_\" && kubectl get pvc web-content-prod -n web -o=jsonpath='{.spec.volumeName}' | sed 's/-/_/g') > volume-name.txt"
(echo -n "trident_" && kubectl get pvc web-content-prod -n web -o=jsonpath='{.spec.volumeName}' | sed 's/-/_/g') > volume-name.txt

echo ""

echo "# Copying the PVC name replacing a character to match with the ONTAP volume name"
echo "(echo -n "{\"source_volume_to_protect\": trident_" && kubectl get pvc web-content-prod -n web -o=jsonpath='{.spec.volumeName}' | sed 's/-/_/g' && echo -n "}") > volume-name-snapmirror.json"
(echo -n "{\"source_volume_to_protect\": trident_" && kubectl get pvc web-content-prod -n web -o=jsonpath='{.spec.volumeName}' | sed 's/-/_/g' && echo -n "}") > volume-name-snapmirror.json
