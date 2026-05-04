# Terraform Module: Azure Container Apps Baseline

Ce module provisionne un socle Azure Container Apps avec:

- Un Resource Group
- Un Log Analytics Workspace
- Un Container Apps Environment
- Une Container App exposée en ingress HTTP/HTTPS

## Prerequisites

- Terraform >= 1.5.0
- Azure subscription
- Azure CLI authentifiée ou variables d'authentification service principal

## Usage

```hcl
module "aca" {
	source = "./"

	location = "westeurope"
	env      = "dev"
	app      = "sample-api"
	image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"

	ingress_target_port = 80
	min_replicas        = 0
	max_replicas        = 3

	additional_tags = {
		owner      = "platform-team"
		cost_center = "it"
	}
}
```

## Example

Un exemple minimal est disponible dans [examples/basic](examples/basic).

Autres exemples disponibles:

- [examples/private-ingress](examples/private-ingress): ingress interne uniquement.
- [examples/production-profile](examples/production-profile): profil plus proche d'un environnement production.
- [examples/http-ingress](examples/http-ingress): ingress public avec HTTP autorise (dev/test).

```bash
cd examples/basic
terraform init
terraform plan
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| location | string | n/a | Azure region (example: westeurope) |
| env | string | n/a | Environment name (2-12 chars, lowercase, alphanumeric, hyphen) |
| app | string | n/a | Application name (2-30 chars, lowercase, alphanumeric, hyphen) |
| image | string | n/a | Container image reference |
| waypoint_application | string | "" | Optional Waypoint application tag |
| resource_suffix | string | "001" | Suffix used in generated resource names |
| additional_tags | map(string) | {} | Additional resource tags |
| log_analytics_sku | string | "PerGB2018" | Log Analytics SKU |
| log_analytics_retention_in_days | number | 30 | Log retention in days (30-730) |
| ingress_allow_insecure_connections | bool | false | Allow HTTP without TLS |
| ingress_external_enabled | bool | true | Expose app publicly |
| ingress_target_port | number | 80 | Container port exposed by ingress |
| container_cpu | number | 0.25 | CPU requested by container |
| container_memory | string | "0.5Gi" | Memory requested by container |
| min_replicas | number | 0 | Minimum replicas |
| max_replicas | number | 3 | Maximum replicas |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Name of the Resource Group |
| resource_group_id | ID of the Resource Group |
| container_app_environment_id | ID of the Container Apps Environment |
| container_app_id | ID of the Container App |
| container_app_fqdn | FQDN of the latest Container App revision |
| container_app_url | HTTPS URL of the Container App |

## Validation and quality checks

```bash
terraform fmt -recursive
terraform init
terraform validate
```

## Continuous Integration

Le workflow GitHub Actions [terraform-ci.yml](.github/workflows/terraform-ci.yml) execute automatiquement:

- terraform fmt -check -recursive
- terraform init -backend=false
- terraform validate
- terraform init/validate sur les exemples [examples/basic](examples/basic), [examples/private-ingress](examples/private-ingress), [examples/production-profile](examples/production-profile), [examples/http-ingress](examples/http-ingress)
