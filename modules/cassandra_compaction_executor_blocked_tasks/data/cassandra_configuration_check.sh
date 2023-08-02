

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