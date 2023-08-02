terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "cassandra_compaction_executor_blocked_tasks" {
  source    = "./modules/cassandra_compaction_executor_blocked_tasks"

  providers = {
    shoreline = shoreline
  }
}