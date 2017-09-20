#!/usr/bin/env python3

import time
from datetime import datetime, timedelta
from tornado import ioloop, httpclient, gen

global i
i, maxI = 0, 25
http_client = httpclient.AsyncHTTPClient()

now = lambda: datetime.now().strftime("%H:%M:%S.%f")

def first_call(response):
    if response.error:
        response.rethrow()
    print ("%s first %d bytes" % (now(), len(response.body)))

    # sleep before starting more requests.
    ioloop.IOLoop.instance().add_timeout(timedelta(seconds=1), second_call)


def second_call():
    # start more requests after a timeout
    for _ in range(maxI):
        http_client.fetch("http://example.org", third_call)


def third_call(response):
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
