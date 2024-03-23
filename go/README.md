# Azure Functions - Go based custom handler

Some sample demo code to demonstrate using ['Azure Functions custom handlers'](https://docs.microsoft.com/en-us/azure/azure-functions/functions-custom-handlers). Custom handlers are lightweight web servers that receive events from the Functions host. Any language that supports HTTP primitives can implement a custom handler.

This sample code implements a Go based handler, as Go is not one of the 1st class langauges supported by Functions, this unlocks the possiblity of using Go with Functions

Ther are three functions:

- **helloFunction**. HTTP trigger (GET or POST), simply echos some information out as JSON
- **resizeImageFunction**. Blob trigger and blob output. Resizes images (JPEG and PNG) in blob storage
- **fractalFunction**. HTTP trigger with returned image content type. Creates a Mandelbrot fractal and returns it as a PNG

This was designed to run on Linux Functions app as a container (Premium Consumption plan or App Service Plan)

All code for the three functions is contained in `main.go` with some suplimental types in `types.go`. This acts as the HTTP server and routes requests to the relevant hander for each function

Some (lots!) of code borrowed from https://github.com/Azure-Samples/functions-custom-handlers

# Setup

Configure `local.settings.json` and set values for `AzureWebJobsStorage` and `blobAccount` to be a valid Azure Storage connection strings (they can be the same or different accounts)

In the storage account pointed to by `blobAccount` create two blob containers:

- golang-photo-in
- golang-photo-out

# Run Locally (Core Tools)

Have Go and [Functions Core Tools](https://github.com/Azure/azure-functions-core-tools) installed

```bash
make run
```

