// The application does the following:
// 0. Call http://dnsgames.
// 1. Call http://example.org/ NUM_EXAMPLE times in parallel.
// 2. Wait 1 second.
// 3. Call http://dnsgames.
// 4. Wait 1 second.
// 5. Quit (or at least, try to). If application does not quit in 5 seconds, kill it.
//
// Exit codes:
// 0 -- success (http://localhost/ call successful).
// 1 -- unknown.
const http = require('http'),
      NUM_EXAMPLE = 25;

http.get("http://localhost:8080", (res) => res.resume())

for (var i = 0; i < NUM_EXAMPLE; i++) {
    setImmediate(() => http.get('http://example.org', (res) => res.resume()))
}

process.exitCode = 1
setTimeout(() => {
    http.get("http://localhost:8080", (res) => {
        process.exitCode = 0
        res.resume()
    })
}, 1000)
