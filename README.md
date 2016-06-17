Node showoff
------------

This script will highlight how a delay to the DNS server can affect downstream
requests from a node server.

Usage:

    $ docker run --privileged -v `pwd`:/blackhole -ti --rm node:0.10 /bin/bash
    # apt-get update && apt-get install -y dnsutils time vim
    # cd /blackhole
    # npm install
    # ./do_test tc_on | bash -x
    # ./do_test test 10

Expected results: the requests will become slower, even ones talking to `localhost`.

Actual results: after the test, any packets going out of eth0 get lost:

    # ping 8.8.8.8
