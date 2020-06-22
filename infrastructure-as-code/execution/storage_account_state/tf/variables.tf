variable environment {}
variable location {}
variable cost_center {}

variable storage_account_state_name {}
variable tbe_resource_group_name {}
variable account_tier {}
variable access_tier { default = "Cool" }
variable account_replication_type {}
variable account_kind {}
variable enable_https_traffic_only { default = false }
#variable enable_file_encryption { default = true }
#variable account_encryption_source { default = "Microsoft.Storage" }
#variable enable_advanced_threat_protection { default = false }

variable tbe_container_name {}
variable container_access_type {}
#variable container_metadata {}