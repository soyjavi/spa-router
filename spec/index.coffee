
SPArouter.listen
  "/hello/world"  : -> console.log "hello world!"
  "/hello/:name"  : (params) -> console.log "hola #{params.name}!"
  "/delay"        : ->
    setTimeout ->
      console.log "delayed"
      SPArouter.path "hello/world"
    , 1000
