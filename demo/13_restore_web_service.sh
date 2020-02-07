#!/bin/bash

clear
persistentVolumeName=$(cat /root/demo-trident/demo/persistent-volume-name.txt)
kubectl patch pv $persistentVolumeName -p '{"spec":{"claimRef":null}}'

echo "Running a yaml files restore for the namespace web..."
echo ""
echo "[root@rhel3 ~]# ./k8s_backup/import.sh"
./k8s_backup/import.sh
