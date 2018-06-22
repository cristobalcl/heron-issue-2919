#!/usr/bin/env bash

set -e

curl -L -O https://pantsbuild.github.io/setup/pants
chmod +x pants
touch pants.ini

# ./pants clean-all --async
./pants binary topologies:WordCountTopology

heron kill heron word-count-topology
heron submit heron ./dist/WordCountTopology.pex  --deploy-deactivated --verbose \
    - word-count-topology
heron activate heron word-count-topology
