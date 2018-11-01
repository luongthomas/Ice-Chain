#!/bin/bash

. ~/.nvm/nvm.sh
nvm use 10.7.0
node -e "console.log('Running Node.js ' + process.version)"

