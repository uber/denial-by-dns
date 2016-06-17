'use strict';
var http = require('http');
var request = require('request');

var PORT = 8080;

var REQUEST_OPTS = {timeout: 1500}

function doRequest(url, resp1) {
    request(url, REQUEST_OPTS, function(error, resp2, body) {
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

function handleRequest(request, response) {
    if (request.url.lastIndexOf("/mj", 0) === 0) {
        doRequest("http://mo.licejus.lt/ip/", response);
    } else if (request.url.lastIndexOf("/local", 0) === 0) {
        doRequest("localhost:8000", response);
    } else {
        response.end("hello you too!\n");
    }
}
var server = http.createServer(handleRequest);

server.listen(PORT, function(){
    console.log("Server listening on: http://localhost:%s", PORT);
});
