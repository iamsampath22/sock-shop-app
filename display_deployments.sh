kubectl -n $1 get deployments -o=custom-columns='DEPLOYMENT_NAME:.metadata.name,IMAGE:.spec.template.spec.containers[*].image,UPDATED:.status.conditions[*].lastUpdateTime'
