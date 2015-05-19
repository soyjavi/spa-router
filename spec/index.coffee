
HTTProuter.listen
  "/hello/world"  : -> console.log "hello world!"
  "/hola/:name"   : (params) -> console.log "hola #{params.name}!"

setTimeout ->
  HTTProuter.path "hola/cataflu"
, 1000
