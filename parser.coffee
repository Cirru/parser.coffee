
parseBlock = ->

parseTree = ->

parse = ->

error = ->

# loader for RequireJS, CommonJS and browsers

if define?
  define
    parse: parse
    error: error
else if exports?
  exports.parse = parse
  exports.error = error
else if window?
  window.parse = parse
  window.error = error