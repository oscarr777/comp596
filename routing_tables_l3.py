import p4runtime_sh.shell as sh

# you can omit the config argument if the switch is already configured with the
# correct P4 dataplane.
sh.setup(
    grpc_addr='localhost:9559',
    election_id=(0, 1), # (high, low)
    config=sh.FwdPipeConfig('build/p4info.txt', 'build/bmv2.json')
)

# see p4runtime_sh/test.py for more examples
te0 = sh.TableEntry('my_ingress.ipv4_match')(action='my_ingress.to_port_action')
te0.match['hdr.ipv4.dst_addr'] = '10.10.0.0/16'
te0.action['port'] = '1'
te0.insert()

te1 = sh.TableEntry('my_ingress.ipv4_match')(action='my_ingress.to_port_action')
te1.match['hdr.ipv4.dst_addr'] = '11.11.0.0/16'
te1.action['port'] = '2'
te1.insert()

te2 = sh.TableEntry('my_ingress.ipv4_match')(action='my_ingress.to_port_action')
te2.match['hdr.ipv4.dst_addr'] = '12.12.0.0/16'
te2.action['port'] = '3'
te2.insert()

te3 = sh.TableEntry('my_ingress.ipv4_match')(action='my_ingress.drop_action')
te3.match['hdr.ipv4.dst_addr'] = '20.20.20.0/24'
te3.insert()

# ...

sh.teardown()