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