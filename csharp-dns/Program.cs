using System;
using System.Net;
using System.Threading;

await Dns.GetHostAddressesAsync("http://localhost:8080");

for (int i = 0; i < 25; i++)
{
    Dns.GetHostAddressesAsync("http://example.org");
}

Thread.Sleep(1000);

Dns.GetHostAddressesAsync("http://localhost:8080");

