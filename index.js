var http = require('http');
var request = require('request');

var TIMEOUT = 2000;
var PORT = 8080;

var REQUEST_OPTS = {timeout: TIMEOUT}

function doRequest(url, resp) {
    request(url, function(error, resp2, body) {
        if (!error) {
            resp1.end(body);
        } else {
            if (error.code) {
                resp1.end("["+url+"] Error code: " + error.code);
            } else if (error.connect === true) {
                resp1.end("["+url+"] Error connect timeout");
            }
        }
    });
}

function handleRequest(req1, resp1) {
    if (request.url.startswith("/mj")) {
        doRequest("http://mo.licejus.lt/ip/");
    } else if (request.url.startswith("/local")) {
        doRequest("localhost:8000");
    } else {
        response.end("hello you too!\n");
    }
}
var server = http.createServer(handleRequest);

server.listen(PORT, function(){
    console.log("Server listening on: http://localhost:%s", PORT);
});
