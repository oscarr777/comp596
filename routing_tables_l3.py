import p4runtime_sh.shell as sh

# you can omit the config argument if the switch is already configured with the
# correct P4 dataplane.
sh.setup(
    device_id=1,
    grpc_addr='localhost:9559',
    election_id=(0, 1), # (high, low)
    config=sh.FwdPipeConfig('build/p4info.txt', 'build/bmv2.json')
)

# see p4runtime_sh/test.py for more examples
te = sh.TableEntry('<table_name>')(action='<action_name>')
te.match['<name>'] = '<value>'
te.action['<name>'] = '<value>'
te.insert()

# ...

sh.teardown()