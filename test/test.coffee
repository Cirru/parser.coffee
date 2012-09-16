
parser = require('../src/parser').parser
fs = require 'fs'
show = console.log
isArr = Array.isArray

test = ->
  file = fs.readFileSync 'file.txt', 'utf8'
  ret = parser file
  show ret

  html = (arr) ->
    a = (item) ->
      if isArr item then html item
      else "<p>#{item.line}</p>"
    ret = arr.map(a).join('')
    "<div>#{ret}</div>"

  style = "
  <style>
    div {
      box-shadow: 0px 0px 6px gray;
      box-sizing: border-box;
      width: 400px;
      padding: 0px 4px;
      margin: 10px 20px;
    }
    p {
      margin: 0px;
      line-height: 30px;
      font-family: 'monospace';
    }
  </style>
  <script src='http://192.168.1.117:8072/doodle.js'></script>
  "

  content = style + (html ret)

  fs.writeFile 'box.html', content

do test
fs.watchFile 'file.txt', {interval: 100}, -> do test