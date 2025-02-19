# mdai-helm-charts

## Publishing a new chart version

```
cd ../mdai-operator
helm package -u deployment
cd -
helm repo index ../mdai-operator --merge index.yaml
mv ../mdai-operator/index.yaml ../mdai-operator/mdai-operator-0.1.4.tgz .
```

Commit and push the `index.yaml` and the `tgz` file.
