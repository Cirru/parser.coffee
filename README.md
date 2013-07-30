
cirru-parser: parser for Cirru language
------

I'm going to rewrite the parse based on my new comprehensions.  
It takes time...

```
status:
  tail:
    [Nil]
    type:
      block
      string
      number
      keyword
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