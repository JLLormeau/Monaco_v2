#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 --aws|--kubernetes|--classic"
    echo "For AWS: $0 --aws --set-account-name=<name> --set-account-id=<id>"
    echo "For Kubernetes: $0 --kubernetes --set-cluster-name=<name>"
    echo "For Classic Deployment: $0 --classic --set-application-name=<name> --set-application-environment=<env>"
    exit 1
}

# Function to create and update a new YAML file for AWS deployment
create_and_update_aws_yaml() {
    local account_name=$1
    local account_id=$2
    local template_file="aws-deployment/management-zone.template"
   
    local new_yaml_file="aws-deployment/management-zone.yaml"

    # Copy the template file to a new YAML file
    if [ -f "$template_file" ]; then
        cp "$template_file" "$new_yaml_file"

        # Replace placeholders in the new YAML file
        sed -i "s/\$account_name/$account_name/g" "$new_yaml_file"
        sed -i "s/\$account_id/$account_id/g" "$new_yaml_file"
    else
        echo "Template file not found: $template_file"
        exit 1
    fi
}

create_and_update_kubernetes_yaml() {
    local cluster_name=$1
    local template_file="kubernetes-deployment/management-zone.template"
   
    local new_yaml_file="kubernetes-deployment/management-zone.yaml"

    # Copy the template file to a new YAML file
    if [ -f "$template_file" ]; then
        cp "$template_file" "$new_yaml_file"

        # Replace placeholders in the new YAML file
        sed -i "s/\$cluster_name/$cluster_name/g" "$new_yaml_file"
    else
        echo "Template file not found: $template_file"
        exit 1
    fi
}

create_and_update_classic_mz_yaml() {
    local application_name=$1
    local application_environment=$2
    local template_file="classic-deployment/management-zone.template"
   
    local new_yaml_file="classic-deployment/management-zone.yaml"

    # Copy the template file to a new YAML file
    if [ -f "$template_file" ]; then
        cp "$template_file" "$new_yaml_file"

        # Replace placeholders in the new YAML file
        sed -i "s/\$application_name/$application_name/g" "$new_yaml_file"
        sed -i "s/\$application_environment/$application_environment/g" "$new_yaml_file"
    else
        echo "Template file not found: $template_file"
        exit 1
    fi
}
create_and_update_classic_yaml()
{
    create_and_update_classic_mz_yaml "$application_name" "$application_environment"
    create_and_update_classic_alerting_profile_yaml "$application_name" "$application_environment"
}
create_and_update_classic_alerting_profile_yaml() {
    local application_name=$1
    local application_environment=$2
    local template_file="classic-deployment/alerting-profile.template"
   
    local new_yaml_file="classic-deployment/alerting-profile.yaml"

    # Copy the template file to a new YAML file
    if [ -f "$template_file" ]; then
        cp "$template_file" "$new_yaml_file"

        # Replace placeholders in the new YAML file
        sed -i "s/\$application_name/$application_name/g" "$new_yaml_file"
        sed -i "s/\$application_environment/$application_environment/g" "$new_yaml_file"
    else
        echo "Template file not found: $template_file"
        exit 1
    fi
}
# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

# Initialize variables
account_name=""
account_id=""
cluster_name=""
application_name=""
application_environment=""
deploy_option=""

# Parse the deployment option and arguments
for arg in "$@"; do
    case $arg in
        --aws)
            deploy_option="aws"
            ;;
        --kubernetes)
            deploy_option="kubernetes"
            ;;
        --classic)
            deploy_option="classic"
            ;;
        --set-account-name=*)
            account_name="${arg#*=}"
            ;;
        --set-account-id=*)
            account_id="${arg#*=}"
            ;;
        --set-cluster-name=*)
            cluster_name="${arg#*=}"
            ;;
        --set-application-name=*)
            application_name="${arg#*=}"
            ;;
        --set-application-environment=*)
            application_environment="${arg#*=}"
            ;;
        *)
            # Ignore unknown arguments
            ;;
    esac
done

# Check if the deployment option is set
if [ -z "$deploy_option" ]; then
    echo "No deployment option provided"
    usage
fi

# AWS deployment logic
if [ "$deploy_option" == "aws" ]; then
    if [ -z "$account_name" ] || [ -z "$account_id" ]; then
        echo "AWS deployment requires account name and ID"
        usage
    fi
    echo "Preparing AWS deployment with account name: $account_name and account ID: $account_id"
    create_and_update_aws_yaml "$account_name" "$account_id"
    ./monaco deploy manifest.yaml --project=aws-deployment
fi

# Kubernetes deployment logic
if [ "$deploy_option" == "kubernetes" ]; then
    if [ -z "$cluster_name" ]; then
        echo "Kubernetes deployment requires cluster name"
        usage
    fi
    echo "Preparing Kubernetes deployment with cluster name: $cluster_name"
    create_and_update_kubernetes_yaml "$cluster_name"
    ./monaco deploy manifest.yaml --project=kubernetes-deployment
fi

# Classic deployment logic
if [ "$deploy_option" == "classic" ]; then
    if [ -z "$application_name" ] || [ -z "$application_environment" ]; then
        echo "Classic deployment requires application name and environment"
        usage
    fi
    echo "Preparing Classic deployment with application name: $application_name and environment: $application_environment"
    create_and_update_classic_yaml "$application_name" "$application_environment"
    ./monaco deploy manifest.yaml --project=classic-deployment
fi
