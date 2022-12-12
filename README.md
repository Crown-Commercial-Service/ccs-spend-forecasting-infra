# Spend Forecasting Infrastructure

## Purpose

This repository contains a collection of Terraform modules which form the basis of the Spend Forecasting project within CCS

## Requirements

- Terraform - 1.3.6 or above
- Azure CLI
- Access to a resource group within an Azure subscription
- Python
    - If Python 3 - 3.6 and above
    - If Python 2 - 2.7.9 and above
- `databricks-cli` ([installation instructions](https://docs.databricks.com/dev-tools/cli/index.html))

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

### Azure Data Factory Github integration

The Data Factory templates are integrated with [the relevant git repository](https://github.com/Crown-Commercial-Service/ccs-spend-forecasting-adf). Due to inconsistencies with how Azure has applied permissions between the GUI and the CLI (see [here](https://github.com/hashicorp/terraform/issues/24449)), it is not possible to terraform the `github_integration` block of the Data Factory without higher level permissions than Resource Group. 

Therefore, upon first creation of the Data Factory (for example, if the whole envionment needed to be removed and recreated), it is necessary to associate the Data Factory with the git repo with the following parameters:

Repository name - `ccs-spend-forecasting-adf`

Collaboration branch - `main`

Publish branch - `adf_publish`

Root folder - `/`

Assuming that the Data Factory is newly created and therefore has no resources, you do not need to tick 'import existing resources to repository'. 


### Databricks workspace

Once the Databricks workspace has been created in the `pipeline` stack, certain actions then need to be taken using an additional authentication method. There are various ways to do this ([documentation](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/cli/)), including authenticating locally using the same Azure AD resource which is used for Azure CLI. However, the tokens issued expire every 24 hours and it was not possible to automate without adding more local files on each developer machine. 

Therefore, in this project, the `provider.tf` configures the databricks provider to use a service principal (defined in the `auth` stack), which  meanas that the user does not have to do any additional manual steps. This could be reconfigured in the future if necessary, just be aware of the `workspace_resource_id` parameter, which is the resource ID (**not** the workspace ID). 



#### Invalid resource ID

If you get `Error: Invalid resource ID` when running `plan`, one of the reasons could be that, rather than an incorrect resource ID being provided as reported, the provider is incorrectly configured.  