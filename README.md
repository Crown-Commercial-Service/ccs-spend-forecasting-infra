# Spend Forecasting Infrastructure

## Purpose

This repository contains a collection of Terraform modules which form the basis of the Spend Forecasting project within CCS

## Requirements

- Terraform
- Azure CLI
- Access to a resource group within an Azure subscription

### Setup

#### Azure

Navigate to the root of the project and run `az login`. A browser will open and you will be prompted to login with your Azure credentials. 

#### Terraform

You need to create a `.tfvars` file with the name of your `STACK_IDENTIFIER`. For example, if your stack is called `Development`, you need to create a `Development.tfvars` file in the root of your project with the following variables:

`resource_group_name` - The name of the resource group you have permissions to deploy into.

`db_connection_string` - The full connection string for the SQL database where you will be reading the data from.

For example:

```
resource_group_name  = "MyRGName"
db_connection_string = "MyFullConnectionString"
```

### Running commands

#### Using the helper script

There is a helper script, `terraform.sh`, which adds some wrappers around the basic `init`, `plan`, and `apply` scripts for Terraform. The usage of this file is `TASK STACK-NAME STACK-IDENTIFIER`, where:

`TASK` = the task you want to run e.g. `init`, `plan`, `apply`

`STACK-NAME` = The name of the terraform stack you want to run e.g. `data`, `network`.

`STACK-IDENTIFIER` = Any string used to identify a particular environment e.g. `Development`, `Testing`, or `Production`

#### Without the helper script

If for any reason you are not able to run the helper script, you can still use the repository in the same way, but for certain commands you will need to specify the `backend-config` parameters for certain commands, as documented in the Terraform [partial configuration docs](https://www.terraform.io/language/settings/backends/configuration#partial-configuration). 

For example:

```
terraform init \
    -backend-config key=<<YOUR STATE KEY HERE>> \
    -backend-config region=<<YOUR REGION HERE>> \
    -backend-config bucket=<<YOUR STATE BUCKET HERE> \
    -backend-config dynamodb_table=<<YOUR DYNAMO DB TABLE HERE>>
```

You will also need to specify the `STACK_NAME` and `STACK_IDENTIFIER` variables for certain commands such as `plan`. 

For example:

```
terraform -chdir=${stack_name} plan \
    -var stack_identifier=<<YOUR STACK ID HERE>> \
    -var state_bucket=<<YOUR STATE BUCKET HERE>> \
    -out==<<YOUR STACK NAME HERE>>-=<<YOUR STACK ID HERE>>.tfplan
;;
```

