import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions'
import * as process from 'process'

/**
 * Handler for very simple HTTP trigger
 * @param request - The incoming HTTP request
 * @param context - The Azure Function context
 */
export async function helloHandler(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`Http function processed request for url "${request.url}"`)

  const name = request.query.get('name') || (await request.text()) || 'unknown person'

  return {
    body: `Hey there, ${name}!`,
  } as HttpResponseInit
}

/**
 * Handler for HTTP trigger that dumps the all environment variables - not very safe!
 */
export async function envDump(): Promise<HttpResponseInit> {
  return {
    body: JSON.stringify(process.env),
    headers: {
      'Content-Type': 'application/json',
    },
  } as HttpResponseInit
}

/**
 * Register Azure Function HTTP triggers
 */
app.http('hello', {
  methods: ['GET', 'POST'],
  authLevel: 'anonymous',
  handler: helloHandler,
})

app.http('envDump', {
  methods: ['GET'],
  authLevel: 'anonymous',
  handler: envDump,
})
