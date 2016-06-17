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
    # ./do_test test 31

Result:

    root@default:/blackhole# ./do_test test 31
    Server listening on: http://localhost:8080
    0.94 [http://1.1907.really.bad] Error code: ENOTFOUND
    0.74 [http://3.1907.really.bad] Error code: ENOTFOUND
    0.84 [http://2.1907.really.bad] Error code: ENOTFOUND
    0.64 [http://4.1907.really.bad] Error code: ENOTFOUND
    1.31 [http://5.1907.really.bad] Error code: ENOTFOUND
    1.24 [http://6.1907.really.bad] Error code: ENOTFOUND
    1.14 [http://7.1907.really.bad] Error code: ENOTFOUND
    0.84 [http://localhost:8000] success: 548
    1.10 [http://8.1907.really.bad] Error code: ENOTFOUND
    1.55 [http://9.1907.really.bad] Error code: ENOTFOUND
    1.54 [http://10.1907.really.bad] Error code: ENOTFOUND
    1.48 [http://11.1907.really.bad] Error code: ENOTFOUND
    1.41 [http://12.1907.really.bad] Error code: ENOTFOUND
    1.76 [http://13.1907.really.bad] Error code: ENOTFOUND
    Done, sleeping
    1.78 [http://14.1907.really.bad] Error code: ENOTFOUND
    1.71 [http://15.1907.really.bad] Error code: ENOTFOUND
    1.65 [http://16.1907.really.bad] Error code: ENOTFOUND
    1.25 [http://localhost:8000] success: 548
    2.03 [http://18.1907.really.bad] Error code: ENOTFOUND
    1.96 [http://19.1907.really.bad] Error code: ENOTFOUND
    3.01 [http://17.1907.really.bad] Error code: ESOCKETTIMEDOUT
    3.02 [http://20.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://21.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://22.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://23.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://24.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://25.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://26.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://27.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://28.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://29.1907.really.bad] Error code: ETIMEDOUT
    3.01 [http://localhost:8000] Error code: ETIMEDOUT
    3.01 [http://30.1907.really.bad] Error code: ESOCKETTIMEDOUT
    3.01 [http://31.1907.really.bad] Error code: ESOCKETTIMEDOUT

Observe the line:

    3.01 [http://localhost:8000] Error code: ETIMEDOUT

Why do you think happens? Because it times out during the DNS query phase,
since the libuv thread pool is exhausted.
