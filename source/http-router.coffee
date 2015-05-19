###
HTML5 API History Wrapper

@namespace HTTProuter

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

HTTProuter = do ->

  _regexp =
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
  @TODO
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
    else
      if _options.absolute then _getPath() else _getHash()

  ###
  @TODO
  @method back
  ###
  _back = ->
    _options.forward = false
    steps = if window.history.state.steps? then window.history.state.steps else 1
    window.history.go -steps

  ###
  @TODO
  @method listen
  ###
  _listen = (paths = {}) ->
    for path, callback of paths

      attributes = ["url"]
      _regexp.attributes.lastIndex = 0
      while (match = _regexp.attributes.exec(path)) != null
        attributes.push(match[1])

      _regexp.splat.lastIndex = 0
      while (match = _regexp.splat.exec(path)) != null
        attributes.push(match[1])

      path = path.replace(_regexp.escape, '\\$&')
                 .replace(_regexp.attributes, '([^\/]*)')
                 .replace(_regexp.splat, '(.*?)')

      _options.routes[path] =
        attributes: attributes
        callback  : callback
        regexp    : new RegExp('^' + path + '$')

    do _onPopState
    window.addEventListener "popstate", _onPopState

  # Private
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
    window.location.hash.replace(_regexp.hash, '')

  _matchRoute = (path, options) ->
    for key of _options.routes
      route = _options.routes[key]
      exec = route.regexp.exec(path)
      if exec
        obj = {}
        obj[attribute] = exec[index] for attribute, index in route.attributes
        route.callback?.call(@, obj)
        break

  path    : _path
  back    : _back
  listen  : _listen
  options : _options

window?.HTTProuter = HTTProuter

module?.exports = HTTProuter
