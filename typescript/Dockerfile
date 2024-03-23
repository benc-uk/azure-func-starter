# Stage 1 - Build
FROM node:18-alpine as build-stage
WORKDIR /build

COPY ./package.json ./
COPY ./package-lock.json ./
RUN npm install

COPY . ./
RUN npm run build

# Stage 2 - Runtime
FROM mcr.microsoft.com/azure-functions/node:4-node18

COPY --from=build-stage /build/dist /home/site/wwwroot/dist/
COPY --from=build-stage /build/node_modules /home/site/wwwroot/node_modules/
COPY --from=build-stage /build/host.json /home/site/wwwroot/
COPY --from=build-stage /build/package.json /home/site/wwwroot/

ENV AzureWebJobsScriptRoot=/home/site/wwwroot 
ENV AzureFunctionsJobHost__Logging__Console__IsEnabled=true
