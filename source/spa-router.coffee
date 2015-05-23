###
HTML5 API History Wrapper

@namespace SPArouter

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

SPArouter = do ->

  REGEXP =
    attributes  : /:([\w\d]+)/g
    splat       : /\*([\w\d]+)/g
    escape      : /[-[\]{}()+?.,\\^$|#\s]/g
    hash        : /^#*/

  _options =
    path     : null
    forward  : true
    absolute : false
    routes   : {}

  ###
  @method path
  @param  {value}    Array of urls with callbacks
  ###
  _path = (args...) ->
    if args.length > 0
      _options.forward = true
      path = "/" + args.join("/")
      unless path is _options.path
        path = "#" + path unless _options.absolute
        state = window.history.state or null
        window.history.pushState state, document.title, path
        _onPopState()
    else if _options.absolute
      _getPath()
    else
      _getHash()

  ###
  @method back
  ###
  _back = ->
    _options.forward = false
    steps = if window.history.state.steps? then window.history.state.steps else 1
    window.history.go -steps

  ###
  @method listen
  @param  {value}  Object with a url matching (key) and callback (value)
  ###
  _listen = (paths = {}) ->
    for path, callback of paths
      attributes = []

      REGEXP.attributes.lastIndex = 0
      attributes.push(match[1]) while (match = REGEXP.attributes.exec(path)) != null
      REGEXP.splat.lastIndex = 0
      attributes.push(match[1]) while (match = REGEXP.splat.exec(path)) != null

      path = path.replace(REGEXP.escape, '\\$&')
                 .replace(REGEXP.attributes, '([^\/]*)')
                 .replace(REGEXP.splat, '(.*?)')

      _options.routes[path] =
        attributes: attributes
        callback  : callback
        regexp    : new RegExp '^' + path + '$'

    do _onPopState
    window.addEventListener "popstate", _onPopState

  # Private events
  _onPopState = (event) ->
    if event then event.preventDefault()
    path = if _options.absolute then _getPath() else _getHash()
    unless path is _options.path
      _options.path = path
      _matchRoute path

  _getPath = ->
    path = window.location.pathname
    path = '/#{path}' if path.substr(0,1) isnt '/'
    path

  _getHash = ->
    window.location.hash.replace(REGEXP.hash, '')

  _matchRoute = (path, options) ->
    for key of _options.routes
      route = _options.routes[key]
      exec = route.regexp.exec path
      if exec
        route.callback?.apply @, (exec[index + 1] for key, index in route.attributes)
        break

  path    : _path
  back    : _back
  listen  : _listen
  options : _options

window?.SPArouter = SPArouter

module?.exports = SPArouter
