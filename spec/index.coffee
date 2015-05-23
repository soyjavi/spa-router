
SPArouter.listen
  "/hello/world"          : -> console.log "hello world!"
  "/hello/:twitter/:name" : (twitter, name) -> console.log "hola #{twitter} #{name}!"
  "/delay"        : ->
    setTimeout ->
      console.log "delayed"
      SPArouter.path "hello/world"
    , 1000
