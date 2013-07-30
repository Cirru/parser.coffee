
{type} = require './util'

class List
  constructor: (@data) ->
    # console.log (type @data)
    if (type @data) is 'string'
      @data = @data.split ''
    else unless (type @data) is 'array'
      throw new Error "wrong usage of List with `#{data}`"

List::__defineGetter__ 'head', -> @data[0]
List::__defineGetter__ 'init', -> @data[...(@data.length - 1)]
List::__defineGetter__ 'body', -> @data[1..]
List::__defineGetter__ 'tail', -> @data[@data.length - 1]

exports.List = List

a = new List 'abc'

unless module.parent
  console.log a.head
  console.log a.init
  console.log a.body
  console.log a.tail