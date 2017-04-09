const http = require('http'),
      NUM_EXAMPLE = 25;

http.get("http://localhost:8080", (res) => res.resume())

for (var i = 0; i < NUM_EXAMPLE; i++) {
    setImmediate(() => http.get('http://example.org', (res) => res.resume()))
}

setTimeout(() => {
    http.get("http://localhost:8080", (res) => {
        res.resume()
    })
}, 1000)
