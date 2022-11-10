#!/usr/bin/env bash

set -e

if [ "$#"  -ne 3 ]; then
    echo "Usage: $0 TASK STACK-NAME STACK-IDENTIFIER"
    exit 1
fi

task=$1
stack_name=$2
stack_identifier=$3

resource_group_name="AzP-UKS-Spend-Forecasting"
container_name="tfstate"
state_key="${stack_name}-${stack_identifier}-terraform.tfstate"
storage_account_name="forecastingtfstate"
tfvars_file="../${stack_identifier}.tfvars"

export TF_DATA_DIR=.terraform/${stack_name}/${stack_identifier}

case "${task}" in
    init)
        terraform -chdir=${stack_name} init \
            -backend-config key=${state_key} \
            -backend-config resource_group_name=${resource_group_name} \
            -backend-config container_name=${container_name} \
            -backend-config storage_account_name=${storage_account_name}
        ;;
    init-migrate)
        terraform -chdir=${stack_name} init \
            -backend-config key=${state_key} \
            -backend-config resource_group_name=${resource_group_name} \
            -backend-config container_name=${container_name} \
            -backend-config storage_account_name=${storage_account_name} -migrate-state
        ;;
    validate)
        terraform -chdir=${stack_name} validate
        ;;
    plan)
        terraform -chdir=${stack_name} plan \
            -var stack_identifier=${stack_identifier} \
            -var-file=${tfvars_file} \
            -out=${stack_name}-${stack_identifier}.tfplan
        ;;
    apply)
        terraform -chdir=${stack_name} apply ${stack_name}-${stack_identifier}.tfplan
        ;;
    destroy)
        terraform -chdir=${stack_name} destroy \
            -var stack_identifier=${stack_identifier} \
            -var-file=${tfvars_file} \
        ;;
    *)
        echo "Unrecognised task: ${task}"
        exit 1
        ;;
esac