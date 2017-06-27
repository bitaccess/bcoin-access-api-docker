#!/bin/bash
node $BCOIN_PATH --network=$NETWORK --prefix $BITCOIN_DIR --coin-cache=100 --index-tx=true --index-address=true --persistent-mempool=true --cache-size=64 --checkpoints=false
