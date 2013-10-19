
# main task

source_file = "../cirru/indent.cr"

req = new XMLHttpRequest
req.open "get", source_file
req.onload = ->
  # cirru.parse.compact = yes
  res = cirru.parse req.response, source_file
  if compactJsonRender?
    compactJsonRender.hide = yes
    console.log compactJsonRender res
  else
    console.log JSON.stringify res
  console.log res
req.send()