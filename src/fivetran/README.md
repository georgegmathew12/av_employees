# Fivetran

Fivetran is configured via the UI today. This directory documents connector setup so it lives in source control.

## Connectors

| Connector | Source | Snowflake destination schema | Sync frequency | Owner |
|-----------|--------|------------------------------|----------------|-------|
| _TBD_     | _TBD_  | _TBD_                        | _TBD_          | _TBD_ |

## Source schema

Document the tables/columns Fivetran is replicating, and any source-side caveats (soft deletes, timezone handling, etc.).

## Managing as code (future)

Once stable, migrate to the [Fivetran Terraform provider](https://registry.terraform.io/providers/fivetran/fivetran/latest/docs) so connector definitions are versioned.
