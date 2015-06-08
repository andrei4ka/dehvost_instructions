#!/bin/bash

. userrc

export POOL_DEFAULT="${POOL}.0.0/16:24"

. /root/fuel-devops-venv/bin/activate
. /root/${USER}/testsrc
sh "/root/fuel-qa/utils/jenkins/system_tests.sh" -t test -w /root/fuel-qa -j "${USER}-venv" -i "$ISO_PATH" -V /root/fuel-devops-venv -o --group=$MY_GROUP $@
