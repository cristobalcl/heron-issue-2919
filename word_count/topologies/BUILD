python_library(
    name = 'word_count',
    sources=globs('*.py', exclude=[['word_count_topology.py']]),
)

python_binary(
    name = 'WordCountTopology',
    source='word_count_topology.py',
    dependencies = [
        ':word_count',
        '3rdparty:heronpy',
        '3rdparty:pyyaml',
        '3rdparty:pyzmq',
        '3rdparty:toolz',
        '3rdparty:numpy',
        '3rdparty:pytz',
        '3rdparty:pandas',
        '3rdparty:pykafka',
        '3rdparty:pyproj',
    ],
)
