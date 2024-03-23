package main

// =====================================================================================================================
// Custom types used by the Functions runtime to call custom handlers
// - and the expected responses
// =====================================================================================================================

// FunctionsInvokeRequest is request input
type FunctionsInvokeRequest struct {
	Data map[string]string

	Metadata struct {
		Properties map[string]any
		Name       string
		Uri        string
		Sys        map[string]any
	}
}

// FunctionsInvokeResponse is response when returning a struct/obj
type FunctionsInvokeResponse struct {
	Outputs     map[string]any
	Logs        []string
	ReturnValue interface{}
}

// FunctionsInvokeResponseString is response when returning a string
type FunctionsInvokeResponseString struct {
	Outputs     map[string]any
	Logs        []string
	ReturnValue string
}
