
# main task

source_file = "../cirru/indent.cr"

req = new XMLHttpRequest
req.open "get", source_file
req.onload = ->
  res = parse req.response, source_file
  console.log JSON.stringify res, null, 2
  console.log res
req.send()