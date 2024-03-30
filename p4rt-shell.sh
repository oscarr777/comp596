#!/bin/bash

python3 -m p4runtime_sh --grpc-addr localhost:9559 --device-id 1 --election-id 0,1 --config build/p4info.txt,build/bmv2.json