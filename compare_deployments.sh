#!/bin/bash

namespace1=$1
namespace2=$2

echo "Comparing deployments in namespaces $namespace1 and $namespace2"

# Get the list of deployments in the first namespace
deployments1=$(kubectl -n $namespace1 get deployments -o=jsonpath="{.items[*].metadata.name}")

# Get the list of deployments in the second namespace
deployments2=$(kubectl -n $namespace2 get deployments -o=jsonpath="{.items[*].metadata.name}")

echo $deploymets1
echo $deployments2
# Compare the lists of deployments and print any missing deployments or differences in image versions
echo "Deployments missing in $namespace1:"
for deployment in $deployments2; do
    if [[ ! " $deployments1 " =~ " $deployment " ]]; then
        echo "- $deployment"
    else
        image1=$(kubectl -n $namespace1 get deployments $deployment -o=jsonpath={.spec.template.spec.containers[*].image})
        image2=$(kubectl -n $namespace2 get deployments $deployment -o=jsonpath={.spec.template.spec.containers[*].image})
        if [[ "$image1" != "$image2" ]]; then
            echo "- $deployment has different image versions:"
            echo "  $namespace1: $image1"
            echo "  $namespace2: $image2"
        fi
    fi
done

echo "Deployments missing in $namespace2:"
for deployment in $deployments1; do
    if [[ ! " $deployments2 " =~ " $deployment " ]]; then
        echo "- $deployment"
    fi
done
