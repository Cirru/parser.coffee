
exports.caution = (char) ->
  filename = char.file.path or '[anonym]'
  loc = "#{filename}: #{char.y + 1}, #{char.x + 1}"
  line = char.file.text.split('\n')[char.y]
  hint = ""
  hint += ' ' while hint.length < char.x
  hint += '^'
  "#{loc}\n#{line}\n#{hint}"