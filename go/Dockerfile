# ===== Build stage ========================================

FROM golang:1.21-bullseye as build
WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

# Build the HTTP hander executable 
COPY src/ ./src
RUN go build -o ./func-server ./src

# ===== Runtime stage ======================================

FROM mcr.microsoft.com/azure-functions/base:4

# !GOTCHA! Must use /home/site/wwwroot otherwise it doesn't work when deployed
WORKDIR /home/site/wwwroot

ENV AzureWebJobsScriptRoot=/home/site/wwwroot
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# Copy in Functions and handler server executable
COPY host.json .
COPY helloFunction/ ./helloFunction
COPY resizeImageFunction/ ./resizeImageFunction
COPY fractalFunction/ ./fractalFunction
COPY --from=build build/func-server ./bin/func-server

CMD [ "/azure-functions-host/Microsoft.Azure.WebJobs.Script.WebHost" ]