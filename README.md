
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra compaction executor blocked tasks.
---

This incident type refers to a situation where some tasks in the Cassandra compaction executor are blocked, impacting the performance of the system. It may occur due to various reasons, such as high resource utilization, hardware failures, or software bugs. This issue needs to be addressed promptly to ensure the smooth functioning of the system.

### Parameters
```shell
# Environment Variables

export PATH_TO_CASSANDRA_LOG="PLACEHOLDER"

export PATH_TO_CASSANDRA_CONFIG="PLACEHOLDER"

export KEYSPACE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"
```

## Debug

### Check CPU and memory utilization
```shell
top
```

### Check disk usage
```shell
df -h
```

### Check if the Cassandra service is running
```shell
systemctl status cassandra
```

### Check Cassandra logs for errors
```shell
tail -f /var/log/cassandra/system.log
```

### Check if compaction is running
```shell
nodetool compactionstats
```

### Check for blocked tasks in compaction
```shell
nodetool tpstats | grep CompactionExecutor | awk '{print $1,$5}'
```

### Configuration issues: Incorrect configuration of the Cassandra cluster or executor can cause tasks to block.
```shell


#!/bin/bash



# Set up variables

cassandraConfig=${PATH_TO_CASSANDRA_CONFIG}

cassandraLog=${PATH_TO_CASSANDRA_LOG}



# Check if Cassandra configuration file exists

if [ ! -f $cassandraConfig/cassandra.yaml ]; then

    echo "Cassandra configuration file not found at $cassandraConfig/cassandra.yaml"

    exit 1

fi



# Check if the Cassandra cluster is running

if ! pgrep -x "cassandra" > /dev/null; then

    echo "Cassandra cluster is not running"

    exit 1

fi



# Check if there are any configuration errors in the log

if grep -q "ERROR" $cassandraLog/system.log; then

    echo "There are configuration errors in the Cassandra log"

    exit 1

fi



# Check if the Cassandra compaction executor is configured correctly

if grep -q "compaction_thread_pool_size" $cassandraConfig/cassandra.yaml; then

    compactionSize=$(grep "compaction_thread_pool_size" $cassandraConfig/cassandra.yaml | awk '{print $2}')

    if [ $compactionSize -lt 2 ]; then

        echo "Compaction thread pool size is too low"

        exit 1

    fi

else

    echo "Compaction thread pool size not found in Cassandra configuration file"

    exit 1

fi



echo "Cassandra cluster is configured correctly"


```

## Repair


### Compact all tables in cassandra database using nodetool utility to force the completion of the blocked compaction task.
```shell
nodetool compact ${KEYSPACE_NAME} ${TABLE_NAME}
```



### Restarting the Cassandra compaction executor can help resolve the issue, as it can clear any stuck tasks and ensure the smooth functioning of the system.
```shell
bash

#!/bin/bash



# Stop the Cassandra compaction executor

sudo service cassandra stop



# Wait for a few seconds to ensure that the service is stopped

sleep 5



# Start the Cassandra compaction executor

sudo service cassandra start



# Check the status of the Cassandra compaction executor

sudo service cassandra status


```