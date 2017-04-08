// Package main creates a web server listening on *:8080, and
// appends datetime of every request to file named args[1].
package main

import (
	"fmt"
	"net/http"
	"time"
)

const NUM_EXAMPLE = 25

// tryUrl sends a GET to a URL and reports it's success or failure
func tryUrl(url string) {
	resp, err := http.Get(url)
	if err != nil {
		fmt.Printf("Error from %s: %s\n", url, err.Error())
	} else {
		fmt.Printf("Reply from %s: %d\n", url, resp.StatusCode)
	}
}

func main() {
	tryUrl("http://localhost:8080")

	for i := 0; i < NUM_EXAMPLE; i++ {
		go func() { tryUrl("http://example.org") }()
	}

	time.Sleep(1 * time.Second)

	tryUrl("http://localhost:8080")

}
