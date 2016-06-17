Node showoff
------------

This script will highlight how a delay to the DNS server can affect downstream
requests from a node server.

Usage:

    npm install
    sudo -v
    ./do_test tc_on | sudo bash -x
    ./do_test test 10

Expected results: the requests will become slower, even ones talking to `localhost`.

Actual results: eth0 is not reachable at all.
