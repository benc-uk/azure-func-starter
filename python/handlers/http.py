import azure.functions as func
import logging
import textwrap
import platform
import json

app = func.FunctionApp()

# Handlers for HTTP triggers


def hello(req: func.HttpRequest) -> func.HttpResponse:
    logging.info("Python HTTP trigger function processed a request.")

    name = req.params.get("name")
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get("name")

    if name:
        return func.HttpResponse(
            f"Hello, {name}. This HTTP triggered function executed successfully."
        )
    else:
        return func.HttpResponse(
            textwrap.dedent(
                """This HTTP triggered function executed successfully.
Pass a name in the query string or in the request body for a
personalized response."""
            ),
            status_code=200,
        )


def sysInfo(req: func.HttpRequest) -> func.HttpResponse:
    # Get memory information from /proc/meminfo
    memory = dict()
    try:
        with open("/proc/meminfo") as f:
            for line in f:
                key, value = line.split(":")
                memory[key] = value.strip()
    except FileNotFoundError:
        memory = {
            "MemTotal": "N/A",
            "MemFree": "N/A",
            "Cached": "N/A",
        }

    return func.HttpResponse(
        json.dumps(
            {
                "system": platform.system(),
                "release": platform.release(),
                "version": platform.version(),
                "machine": platform.machine(),
                "architecture": platform.architecture()[0],
                "python": platform.python_version(),
                "memory": {
                    "total": memory["MemTotal"],
                    "free": memory["MemFree"],
                    "cached": memory["Cached"],
                }
                
            }
        ),
        mimetype="application/json",
    )