# mdai-helm-charts

## Publishing a new chart version

```
cd ../mydecisive-engine-operator
helm package -u deployment
cd -
helm repo index ../mydecisive-engine-operator --merge index.yaml
mv ../mydecisive-engine-operator/index.yaml ../mydecisive-engine-operator/mydecisive-engine-operator-0.0.3.tgz .
```

Commit and push the `index.yaml` and the `tgz` file.
