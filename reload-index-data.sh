#!/bin/bash

#
# This script drops all indices and data from the Elastic Search and reloads it fresh.
#
# ASSUMPTIONS:
# -- Elastic Search and Logstash are both installed and running
# -- Script is executed on the host that ES and LS are installed on.
# -- Data files are located in the same directory as this script
#
SUCCESS=0
ERROR=1
HOST=$1
DATA_FILE=$2

# Deleete Indices
curl -XDELETE http://$HOST:9200/projects


# Create mapping for index
curl -XPUT http://$HOST:9200/projects/ -d '{
    "mappings" : {
        "logs" : {
            "properties" : {
                "project_name" : {
                    "type" : "string"
                },
                "project_description" : {
                    "type" : "string"
                },
                "content" : {
                    "type" : "string"
                },
                "contributors_list" : {
                    "type" : "object"
                },
                "suggest" : {
                    "type" : "completion",
                    "analyzer" : "simple",
                    "search_analyzer" : "simple"
                }
            }
        }
    }
}'

# copy data file to server for Logstash to load
curl -XPOST http://$HOST:9200/projects/logs/_bulk --data-binary @$DATA_FILE

exit $SUCCESS