'''Example WordCountTopology'''
import sys

import heronpy.api.api_constants as constants
from heronpy.api.topology import TopologyBuilder
from heronpy.api.stream import Grouping
from spout import WordSpout
from bolt import CountBolt

# Topology is defined using a topology builder
# Refer to multi_stream_topology for defining a topology by subclassing Topology
# pylint: disable=superfluous-parens
if __name__ == '__main__':
  if len(sys.argv) != 2:
    print("Topology's name is not specified")
    sys.exit(1)

  builder = TopologyBuilder(name=sys.argv[1])

  word_spout = builder.add_spout("word_spout", WordSpout, par=2)
  count_bolt = builder.add_bolt("count_bolt", CountBolt, par=2,
                                inputs={word_spout: Grouping.fields('word')},
                                config={constants.TOPOLOGY_TICK_TUPLE_FREQ_SECS: 10})

  topology_config = {constants.TOPOLOGY_RELIABILITY_MODE:
                         constants.TopologyReliabilityMode.ATLEAST_ONCE}
  builder.set_config(topology_config)

  builder.build_and_submit()
