#!/bin/bash

# All dependencies are expected to be in the same directory as this script
SUCCESS=0
ERROR=1

scp -i <ENTER PEM FILE> reload-index-data.sh organization_info.json ec2-user@<ENTER IP>:~

exit $SUCCESS