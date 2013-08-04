
cirru-parser: parser for Cirru language
------

I'm going to rewrite the parse based on my new comprehensions.  
It takes time...

fisrt, tokenize the text:

```

```

than build a parse tree:

```
status:
  tail:
    [Nil]
    type:
      block
      string
      newline
      escape
    line:
      [Line Number]
    offset:
      [Line Offset]
  level:
    [Number]
  buffer:
    [String]
  line:
    [Line Number]
  offset:
    [Line Offset]
```