// Package main creates a web server listening on *:8080, and
// appends datetime of every request to file named args[1].
package main

import (
	"fmt"
	"net/http"
	"os"
	"path"
	"time"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintf(os.Stderr, "usage: %s <outfile>\n", path.Base(os.Args[0]))
		os.Exit(1)
	}
	fn := os.Args[1]
	f, err := os.OpenFile(fn, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error openining %s for writing: %s\n", fn, err.Error())
		os.Exit(1)
	}
	defer f.Close()

	http.Handle("/health", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("ok\n"))
	}))
	http.Handle("/", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ret := []byte(fmt.Sprintf("success %s\n", time.Now().Format(time.RFC3339)))
		w.Write(ret)
		f.Write(ret)
	}))
	fmt.Println("Listening on :8080 ...")
	panic(http.ListenAndServe(":8080", nil))
}
