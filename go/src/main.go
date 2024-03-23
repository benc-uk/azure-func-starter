package main

// =====================================================================================================================
// This is a custom function handler for Azure Functions
// It is a simple HTTP server that listens for requests and invokes the appropriate function handler
// =====================================================================================================================

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

// Entry point, create regular plain ol' HTTP server as a custom function handler
func main() {
	httpInvokerPort, exists := os.LookupEnv("FUNCTIONS_CUSTOMHANDLER_PORT")

	if exists {
		log.Println("### FUNCTIONS_CUSTOMHANDLER_PORT: " + httpInvokerPort)
	} else {
		log.Fatalln("### FUNCTIONS_CUSTOMHANDLER_PORT not set, goodbye cruel world!")
	}

	// This is not an official setting, but it allows flexibility in the route prefix
	prefix := ""
	if os.Getenv("FUNCTIONS_ROUTE_PREFIX") != "" {
		prefix = os.Getenv("FUNCTIONS_ROUTE_PREFIX")
	}

	// Create a simple HTTP server and register our function handlers
	mux := http.NewServeMux()
	mux.HandleFunc(prefix+"/helloFunction", helloFunctionHandler)
	mux.HandleFunc(prefix+"/resizeImageFunction", resizerFunctionHandler)
	mux.HandleFunc(prefix+"/fractalFunction", fractalFunctionHandler)

	log.Println("### Function handler server started on port:", httpInvokerPort)

	err := http.ListenAndServe(fmt.Sprintf(":%v", httpInvokerPort), mux)
	if err != nil {
		panic(err.Error())
	}
}
