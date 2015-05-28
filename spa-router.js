/**
 * spa-router - Single Page Application Router
 * @version v0.5.23
 * @link    https://github.com/soyjavi/spa-router
 * @author   ()
 * @license MIT
 */
(function(){"use strict";var SPArouter,slice=[].slice;SPArouter=function(){var REGEXP,_back,_getHash,_getPath,_listen,_listening,_matchRoute,_onPopState,_options,_path;return REGEXP={attributes:/:([\w\d]+)/g,splat:/\*([\w\d]+)/g,escape:/[-[\]{}()+?.,\\^$|#\s]/g,hash:/^#*/},_options={path:null,forward:!0,absolute:!1,routes:{}},_listening=!1,_path=function(){var args,path,state;return args=1<=arguments.length?slice.call(arguments,0):[],args.length>0?(_options.forward=!0,path="/"+args.join("/"),path!==_options.path?(_options.absolute||(path="#"+path),state=window.history.state||null,window.history.pushState(state,document.title,path),_onPopState()):void 0):_options.absolute?_getPath():_getHash()},_back=function(){var ref,ref1,steps;return _options.forward=!1,steps=null!=(null!=(ref=window.history.state)?ref.steps:void 0)?null!=(ref1=window.history.state)?ref1.steps:void 0:1,window.history.go(-steps)},_listen=function(paths){var attributes,callback,match,path;null==paths&&(paths={});for(path in paths){for(callback=paths[path],attributes=[],REGEXP.attributes.lastIndex=0;null!==(match=REGEXP.attributes.exec(path));)attributes.push(match[1]);for(REGEXP.splat.lastIndex=0;null!==(match=REGEXP.splat.exec(path));)attributes.push(match[1]);path=path.replace(REGEXP.escape,"\\$&").replace(REGEXP.attributes,"([^/]*)").replace(REGEXP.splat,"(.*?)"),_options.routes[path]={attributes:attributes,callback:callback,regexp:new RegExp("^"+path+"$")}}return _onPopState(),_listening?void 0:(window.addEventListener("popstate",_onPopState),_listening=!0)},_onPopState=function(event){var path;return event&&event.preventDefault(),path=_options.absolute?_getPath():_getHash(),path!==_options.path?(_options.path=path,_matchRoute(path)):void 0},_getPath=function(){var path;return path=window.location.pathname,"/"!==path.substr(0,1)&&(path="/#{path}"),path},_getHash=function(){return window.location.hash.replace(REGEXP.hash,"")},_matchRoute=function(path,options){var exec,index,key,ref,results,route;results=[];for(key in _options.routes){if(route=_options.routes[key],exec=route.regexp.exec(path)){null!=(ref=route.callback)&&ref.apply(this,function(){var i,len,ref1,results1;for(ref1=route.attributes,results1=[],index=i=0,len=ref1.length;len>i;index=++i)key=ref1[index],results1.push(exec[index+1]);return results1}());break}results.push(void 0)}return results},{path:_path,back:_back,listen:_listen,options:_options}}(),"undefined"!=typeof window&&null!==window&&(window.SPArouter=SPArouter),"undefined"!=typeof module&&null!==module&&(module.exports=SPArouter)}).call(this);