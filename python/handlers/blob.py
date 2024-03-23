import logging
import azure.functions as func

# Handlers for blob triggers

def example(myblob: func.InputStream):
    logging.info(
        f"Blob trigger function processed blob \n"
        f"Name: {myblob.name}\n"
        f"Blob Size: {myblob.length} bytes"
    )
