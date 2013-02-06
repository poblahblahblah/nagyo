#!/bin/bash

# nagyo-worker.rb is a ruby script and the incantation is a bit involved - 
# provide this utility script to run with production options

export PATH=/usr/local/rvm/bin:$PATH

export NAGYO_WORKER_PATH=${NAGYO_WORKER_PATH:-"/data/svc/ops/nagyo/nagyo-worker"}
export NAGYO_WORKER_GEMSET=${NAGYO_WORKER_GEMSET:-"ruby-1.8.7@nagyo-worker"}

export NAGYO_WORKER_OPTS=${NAGYO_WORKER_OPTS:-"--sync --debug --config nagyo-worker.yml"}
###

cd $NAGYO_WORKER_PATH || exit 1

worker_script="./bin/nagyo-worker.rb"
if [[ ! -f $worker_script ]] ; then
  echo "Unable to find $worker_script in NAGYO_WORKER_PATH=$NAGYO_WORKER_PATH"
  exit 3
fi

/usr/local/rvm/bin/rvm $NAGYO_WORKER_GEMSET do bundle exec ./bin/nagyo-worker.rb $NAGYO_WORKER_OPTS
