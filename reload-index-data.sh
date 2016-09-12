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

# Deleete Indices
sudo curl -XDELETE http://localhost:9200/projects


# Create mapping for index
sudo curl -XPUT http://localhost:9200/projects/ -d '{
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
sudo cp -f organization_info.json /opt/heimdall

sudo /opt/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf

exit $SUCCESS