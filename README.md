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

Default node options
--------------------

Result:

    root@3edf375f898e:/blackhole# ./do_test test 30
    Server listening on: http://localhost:8080
    1.06 [http://1.44.really.bad] Error code: ENOTFOUND
    0.66 [http://localhost:8000] success: 592
    1.04 [http://2.44.really.bad] Error code: ENOTFOUND
    1.15 [http://3.44.really.bad] Error code: ENOTFOUND
    1.05 [http://4.44.really.bad] Error code: ENOTFOUND
    1.56 [http://5.44.really.bad] Error code: ENOTFOUND
    1.16 [http://localhost:8000] success: 592
    1.57 [http://6.44.really.bad] Error code: ENOTFOUND
    1.65 [http://7.44.really.bad] Error code: ENOTFOUND
    1.55 [http://8.44.really.bad] Error code: ENOTFOUND
    Done, sleeping 4 secs
    2.07 [http://9.44.really.bad] Error code: ENOTFOUND
    1.68 [http://localhost:8000] success: 592
    2.07 [http://10.44.really.bad] Error code: ENOTFOUND
    2.16 [http://11.44.really.bad] Error code: ENOTFOUND
    2.06 [http://12.44.really.bad] Error code: ENOTFOUND
    2.58 [http://13.44.really.bad] Error code: ENOTFOUND
    2.18 [http://localhost:8000] success: 592
    2.57 [http://14.44.really.bad] Error code: ENOTFOUND
    2.67 [http://15.44.really.bad] Error code: ENOTFOUND
    2.57 [http://16.44.really.bad] Error code: ENOTFOUND
    3.01 [http://17.44.really.bad] Error code: ETIMEDOUT
    2.69 [http://localhost:8000] success: 592
    3.01 [http://18.44.really.bad] Error code: ETIMEDOUT
    3.01 [http://19.44.really.bad] Error code: ESOCKETTIMEDOUT
    3.01 [http://20.44.really.bad] Error code: ETIMEDOUT
    3.01 [http://21.44.really.bad] Error code: ETIMEDOUT
    3.01 [http://22.44.really.bad] Error code: ETIMEDOUT
    3.01 [http://23.44.really.bad] Error code: ESOCKETTIMEDOUT
    3.01 [http://24.44.really.bad] Error code: ESOCKETTIMEDOUT
    3.01 [http://localhost:8000] Error code: ESOCKETTIMEDOUT
    Done
    root@3edf375f898e:/blackhole#

Observe that request durations are increasing, of those going locally too.

We believe this happens because the DNS query phase times out, since the libuv
thread pool is exhausted, and there are no workers in the pool to use.

With the fix
------------

    root@2fa65680dd87:/blackhole# export UV_THREADPOOL_SIZE=30
    root@2fa65680dd87:/blackhole# ./do_test test 30
    Server listening on: http://localhost:8080
    0.02 [http://localhost:8000] success: 592
    0.01 [http://localhost:8000] success: 592
    1.04 [http://1.38.really.bad] Error code: ENOTFOUND
    1.03 [http://2.38.really.bad] Error code: ENOTFOUND
    1.03 [http://3.38.really.bad] Error code: ENOTFOUND
    1.03 [http://4.38.really.bad] Error code: ENOTFOUND
    0.01 [http://localhost:8000] success: 592
    1.02 [http://5.38.really.bad] Error code: ENOTFOUND
    1.03 [http://6.38.really.bad] Error code: ENOTFOUND
    1.03 [http://7.38.really.bad] Error code: ENOTFOUND
    1.03 [http://8.38.really.bad] Error code: ENOTFOUND
    0.01 [http://localhost:8000] success: 592
    1.02 [http://9.38.really.bad] Error code: ENOTFOUND
    1.03 [http://10.38.really.bad] Error code: ENOTFOUND
    1.03 [http://11.38.really.bad] Error code: ENOTFOUND
    1.03 [http://12.38.really.bad] Error code: ENOTFOUND
    0.01 [http://localhost:8000] success: 592
    1.03 [http://13.38.really.bad] Error code: ENOTFOUND
    1.03 [http://14.38.really.bad] Error code: ENOTFOUND
    1.03 [http://15.38.really.bad] Error code: ENOTFOUND
    1.03 [http://16.38.really.bad] Error code: ENOTFOUND
    Done, sleeping 4 secs
    0.01 [http://localhost:8000] success: 592
    1.03 [http://17.38.really.bad] Error code: ENOTFOUND
    1.02 [http://18.38.really.bad] Error code: ENOTFOUND
    1.03 [http://19.38.really.bad] Error code: ENOTFOUND
    1.03 [http://20.38.really.bad] Error code: ENOTFOUND
    1.02 [http://21.38.really.bad] Error code: ENOTFOUND
    1.02 [http://22.38.really.bad] Error code: ENOTFOUND
    1.02 [http://23.38.really.bad] Error code: ENOTFOUND
    1.02 [http://24.38.really.bad] Error code: ENOTFOUND
    Done

Also works by adding `process.env.UV_THREADPOOL_SIZE = 30;` just after the
shebang line of the entry point.
