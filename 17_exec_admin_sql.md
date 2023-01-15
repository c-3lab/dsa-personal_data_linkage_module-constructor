# start a psql container

```
utils/start_psql_pod.sh
```

# copy sql files to the started container
```
source .env
kubectl --namespace $NAMESPACE cp ./sql/insert_admin.sql pg:/opt
```

# execute below commands
```
\i /opt/insert_admin.sql
\q
```

