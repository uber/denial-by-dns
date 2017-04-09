package main

import (
	"net/http"
	"time"
)

const NUM_EXAMPLE = 25

func main() {
	http.Get("http://localhost:8080")

	for i := 0; i < NUM_EXAMPLE; i++ {
		go func() { http.Get("http://example.org") }()
	}

	time.Sleep(1 * time.Second)

	http.Get("http://localhost:8080")

}
