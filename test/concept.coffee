
print = (args...) -> console.log args...

person =
  init: (@name) ->
  say: -> print "here is #{@name}"
  rename: (@name) ->

lily = __proto__: person
# I think we need `@` as an alias for `__proto__`
# lily = @: persion
# lily@ = person
lily.init 'lily'
lily.say()