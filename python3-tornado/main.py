#!/usr/bin/env python3

import time
from datetime import datetime
from tornado import ioloop, httpclient, gen

global i
i, maxI = 0, 25
http_client = httpclient.AsyncHTTPClient()

now = lambda: datetime.now().strftime("%H:%M:%S.%f")

def first_call(response):
    if response.error:
        response.rethrow()
    print ("%s first %d bytes" % (now(), len(response.body)))

    # sleep before starting more requests. FIXME make this not block the event loop!
    time.sleep(1)

    # start more requests after a while
    for _ in range(maxI):
        http_client.fetch("http://example.org", second_call)


def second_call(response):
    if response.error:
        response.rethrow()
    print ("%s second %d bytes" % (now(), len(response.body)))
    global i
    i += 1
    if i == maxI:
        http_client.fetch("http://localhost:8080/", final_call)


def final_call(response):
    print ("%s final %d bytes" % (now(), len(response.body)))
    ioloop.IOLoop.instance().stop()


if __name__ == '__main__':
    http_client.fetch("http://localhost:8080/", first_call)
    ioloop.IOLoop.instance().start()
