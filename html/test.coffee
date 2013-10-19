
# main task

source_file = "../cirru/indent.cr"

q = (query) ->
  document.querySelector query

req = new XMLHttpRequest
req.open "get", source_file
req.send()
req.onload = ->
  cirru.parse.compact = yes
  q("textarea.demo").value = req.response
  paint req.response

paint = (text) ->
  console.clear()
  res = cirru.parse text, source_file
  if compactJsonRender?
    compactJsonRender.hide = yes
    lines = compactJsonRender res
  else
    lines = JSON.stringify res
  q("pre.demo").innerHTML = lines
  console.log res

q("textarea.demo").addEventListener "keyup", ->
  paint @value