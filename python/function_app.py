import azure.functions as func
from handlers import http as http_handlers
from handlers import blob as blob_handlers

app = func.FunctionApp()


@app.route(route="hello", auth_level=func.AuthLevel.ANONYMOUS)
def helloRoute(req: func.HttpRequest) -> func.HttpResponse:
    return http_handlers.hello(req)

@app.route(route="info", auth_level=func.AuthLevel.ANONYMOUS)
def infoRoute(req: func.HttpRequest) -> func.HttpResponse:
    return http_handlers.sysInfo(req)


@app.blob_trigger(arg_name="myblob", path="python-in", connection="blobStorage")
def blobTrigger(myblob: func.InputStream):
    return blob_handlers.example(myblob)
