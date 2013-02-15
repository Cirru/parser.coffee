## Cirru-parser

#### Example

For code like:

```
set a 1
set b (string a)

print
  eval (read a)

let
    a 1
    b 2

  print a b
```

Parsing result will be:

```json
[
  [
    "set",
    "a",
    "1"
  ],
  [
    "set",
    "b",
    [
      "string",
      "a"
    ]
  ],
  [
    "print",
    [
      "eval",
      [
        "read",
        "a"
      ]
    ]
  ],
  [
    "let",
    [
      [
        "a",
        "1"
      ],
      [
        "b",
        "2"
      ]
    ],
    [
      "print",
      "a",
      "b"
    ]
  ]
]

```

### Cirru's syntax

* parentheses, indentations, whitespaces consists the rules  
* its syntax tree is merely a list of lists and strings  
* it's a simplest, indetation-sensitive syntax  

### Usage

```
npm install cirru-parser
```

Import it in Node, an example in CoffeeScript:  

```coffee
parse = require("cirru-parser").parse
parse "print\n  string a"
# [ [ 'print', [ 'string', 'a' ] ] ]
```