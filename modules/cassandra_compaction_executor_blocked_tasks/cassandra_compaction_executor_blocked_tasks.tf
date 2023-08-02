resource "shoreline_notebook" "cassandra_compaction_executor_blocked_tasks" {
  name       = "cassandra_compaction_executor_blocked_tasks"
  data       = file("${path.module}/data/cassandra_compaction_executor_blocked_tasks.json")
  depends_on = [shoreline_action.invoke_cassandra_configuration_check,shoreline_action.invoke_stop_start_cassandra_compaction]
}

resource "shoreline_file" "cassandra_configuration_check" {
  name             = "cassandra_configuration_check"
  input_file       = "${path.module}/data/cassandra_configuration_check.sh"
  md5              = filemd5("${path.module}/data/cassandra_configuration_check.sh")
  description      = "Configuration issues: Incorrect configuration of the Cassandra cluster or executor can cause tasks to block."
  destination_path = "/agent/scripts/cassandra_configuration_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "stop_start_cassandra_compaction" {
  name             = "stop_start_cassandra_compaction"
  input_file       = "${path.module}/data/stop_start_cassandra_compaction.sh"
  md5              = filemd5("${path.module}/data/stop_start_cassandra_compaction.sh")
  description      = "Restarting the Cassandra compaction executor can help resolve the issue, as it can clear any stuck tasks and ensure the smooth functioning of the system."
  destination_path = "/agent/scripts/stop_start_cassandra_compaction.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cassandra_configuration_check" {
  name        = "invoke_cassandra_configuration_check"
  description = "Configuration issues: Incorrect configuration of the Cassandra cluster or executor can cause tasks to block."
  command     = "`/agent/scripts/cassandra_configuration_check.sh`"
  params      = ["PATH_TO_CASSANDRA_CONFIG","PATH_TO_CASSANDRA_LOG"]
  file_deps   = ["cassandra_configuration_check"]
  enabled     = true
  depends_on  = [shoreline_file.cassandra_configuration_check]
}

resource "shoreline_action" "invoke_stop_start_cassandra_compaction" {
  name        = "invoke_stop_start_cassandra_compaction"
  description = "Restarting the Cassandra compaction executor can help resolve the issue, as it can clear any stuck tasks and ensure the smooth functioning of the system."
  command     = "`/agent/scripts/stop_start_cassandra_compaction.sh`"
  params      = []
  file_deps   = ["stop_start_cassandra_compaction"]
  enabled     = true
  depends_on  = [shoreline_file.stop_start_cassandra_compaction]
}

