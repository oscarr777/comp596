#include <core.p4>
#include <v1model.p4>

typedef bit<48> EthernetAddress;

header ethernet_t {
    EthernetAddress dst_addr;
    EthernetAddress src_addr;
    bit<16>         ether_type;
}

struct headers_t {
    ethernet_t ethernet;
}

struct metadata_t {
}

error {
    IPv4IncorrectVersion,
    IPv4OptionsNotSupported
}

parser my_parser(packet_in packet,
                out headers_t hd,
                inout metadata_t meta,
                inout standard_metadata_t standard_meta)
{
    state start {
        packet.extract(hd.ethernet);
        transition select(hd.ethernet.ether_type) {
            default: accept;
        }
    }

}

control my_deparser(packet_out packet,
                   in headers_t hdr)
{
    apply {
        packet.emit(hdr.ethernet);
    }
}

control my_verify_checksum(inout headers_t hdr,
                         inout metadata_t meta)
{
    apply {}
}

control my_compute_checksum(inout headers_t hdr,
                          inout metadata_t meta)
{
    apply {}
}

control my_ingress(inout headers_t hdr,
                  inout metadata_t meta,
                  inout standard_metadata_t standard_metadata)
{
    bool dropped = false;

    action drop_action() {
        mark_to_drop(standard_metadata);
        dropped = true;
    }

    action l2_forward(bit<9> port) {
        standard_metadata.egress_port = port;
    }

    table l2switch_table {
        key = {
            hdr.ethernet.src_addr: exact;
        }

        actions = {
            l2_forward;
            NoAction;
        }

        size = 256;
        default_action = NoAction();
    }

    apply {
        l2switch_table.apply();
        if (dropped) return;
    }
}

control my_egress(inout headers_t hdr,
                 inout metadata_t meta,
                 inout standard_metadata_t standard_metadata)
{
    apply {}
}

V1Switch(my_parser(),
         my_verify_checksum(),
         my_ingress(),
         my_egress(),
         my_compute_checksum(),
         my_deparser()) main;