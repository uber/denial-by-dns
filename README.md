dnsgames
========

Infrastructure to test `getaddrinfo()` when DNS servers are timing out.

Running and building the container
----------------------------------

List of tested programming languages:

| Name | Comment | Safe |
| ---- | ------- | ------ |
| golang-http | Golang 1.8 with net/http from stdlib | safe |
| nodejs-http | Node 7 with 'http' from stdlib | unsafe |
