[![Build Status](https://travis-ci.org/Motiejus/blackhole.svg?branch=master)](https://travis-ci.org/Motiejus/blackhole)

dnsgames
========

Infrastructure to test `getaddrinfo()` when DNS servers are timing out.

Problem statement
-----------------

If a service resolves and opens connections to dependencies through DNS, a
flaky DNS of the dependency can DOS the service by preventing opening new
connections to seemingly innocent endpoints like `localhost`.

This repository provides information about which programming languages and
development environments are vulnerable.

How it works
------------

For every language/environment, a container is configured with:

* Unreachable DNS server.
* HTTP server running on `:8080` and logging to a known path.

An environment test does the following:

* Call `http://localhost:8080/`. This call should always succeed; if it
  doesn't, there is an error in the test.
* Call `http://example.org` `N` times in parallel, do not wait for the result.
  `N` depends on knowledge of the environment, usually a few more than the
  default thread pool size.
* Wait 1 second to make sure all calls of the above are scheduled.
* Call `http://localhost:8080/`. This call will succeed iff the application is
  not vulnerable.

Scripts checks the number of times `http://localhost:8080/` is called:
* **0**: there is an error with the setup. Script should succeed at least once.
* **1**: application is vulnerable. First invocation succeeded, second failed.
* **2**: application is not vulnerable.

Results
-------

List of tested programming languages:

| Name | Comment | Safe |
| ---- | ------- | ------ |
| golang-http | Golang 1.8 with 'net/http' from stdlib | safe |
| nodejs-http | Node 7 with 'http' from stdlib | unsafe |
