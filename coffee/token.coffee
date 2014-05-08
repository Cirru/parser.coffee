
exports.Token = class Token

  constructor: (char) ->
    @_data = {}
    @_text = char.getText()
    @_sx = @_ex = char.x
    @_sy = @_ey = char.y
    @_file = char.file

    @isBare = yes

  isExp: no
  isToken: yes

  setStart: (start) ->
    @_sx = start.x
    @_sy = start.y

  setEnd: (end) ->
    @_ex = end.ex
    @_ey = end.ey

  isComma: ->
    @isBare and (@_text is ',')

  isDollar: ->
    @isBare and (@_text is '$')

  isLeftParen: ->
    @isBare and (@_text is '\(')

  isRightParen: ->
    @isBare and (@_text is '\)')

  addChar: (char) ->
    @_text += char.getText()
    @_ex = char.x
    @_ey = char.y

  getText: ->
    @_text

  getStart: ->
    x: @_sx, y: @_sy

  getEnd: ->
    x: @_ex, y: @_ey

  getFile: ->
    @_file

  getStand: ->
    text: @_text
    x: @_sx
    y: @_sy
    file: @_file
    end:
      x: @_ex
      y: @_ey
