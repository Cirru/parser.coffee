
Cirru Parser
------

Cirru is a indentation based grammer for simplicity.
You may use it to DIY DSLs or scripting languages.

It not designed for tough programming tasks,
but for small ones where people want to make coding fun.

### API

* parse:

Parse code, filename is optional and useless in compact mode.

```
parse :: String, String, Bool -> Array[]
tree = parse (content, filename)

parseShort :: String, String, Bool -> Array[]
tree = parseShort (content, filename)
```

`filename` is optional.

`parseShort` returns syntax tree with file infos.

#### In Node

```
npm install --save cirru-parser
```
``` coffee
{parse} = require 'cirru-parser'
ast = parse 'code', './file_path.cirru'
```

#### RequireJS

Link http://exportsjs.u.qiniudn.com/cirru-parser.js

```coffee
window.cirru.parse 'code'
```

It could be also used with RequireJS.

```coffee
define (require, exports) ->
  {parse} = require("../bower_components/cirru-parser/parser")
```

### Live demo

Visit (tested on Chrome): http://repo.jiyinyiyong.me/cirru-parser/  
By typing at right you should see the code updates

### Syntax

* Lines

Mutiple lines:

```cirru
line 1
line 2
line-3
line 4
```
```json
[
  [
    "line",
    "1"
  ],
  [
    "line",
    "2"
  ],
  [
    "line-3"
  ],
  [
    "line",
    "4"
  ]
]
```

* Parentheses

Parentheses create nesting blocks.
But each open bracket its close bracket should be kept in the same line.

```cirru
3 4 (1) 4

((((1))))

x
```
```json
[
  [
    "3",
    "4",
    [
      "1"
    ],
    "4"
  ],
  [
    [
      [
        [
          [
            "1"
          ]
        ]
      ]
    ]
  ],
  [
    "x"
  ]
]
```

* Double quote and escape

Strings are wrapped in `"`s.
Meanwhile single quotes are regarded as plain text.

```cirru
a b c d
"a b c d"
"a b \" c d"
```
```json
[
  [
    "a",
    "b",
    "c",
    "d"
  ],
  [
    "a b c d"
  ],
  [
    "a b \" c d"
  ]
]
```

### Indentations

Cirru must be an indentation-sensitive language:

```cirru
a
  b
    c
e f
    g
  h
```
```json
[
  [
    "a",
    [
      "b",
      [
        "c"
      ]
    ]
  ],
  [
    "e",
    "f",
    [
      [
        "g"
      ]
    ],
    [
      "h"
    ]
  ]
]
```

### Folding indentations

`$` is used in reducing indentations:

```cirru
a $

b $ c

d $ e
  f

g $ h
  i j $ k $
```
```json
[
  [
    "a",
    []
  ],
  [
    "b",
    [
      "c"
    ]
  ],
  [
    "d",
    [
      "e",
      [
        "f"
      ]
    ]
  ],
  [
    "g",
    [
      "h",
      [
        "i",
        "j",
        [
          "k",
          []
        ]
      ]
    ]
  ]
]
```

### Unfolding with `,`

```cirru
set
  add 1
  , x y (add 5)
  add 2
```
```json
[
  [
    "set",
    [
      "add",
      "1"
    ],
    "x",
    "y",
    [
      "add",
      "5"
    ],
    [
      "add",
      "2"
    ]
  ]
]
```

### A glance of Cirru

Combine the syntax rules above:

```cirru
define a (read cd)
  if (> a cd)
    print "demo"
    print "not demo"

say $ print a
  save $ b
    x $ c 8

print "fun"
```
```json
[
  [
    "define",
    "a",
    [
      "read",
      "cd"
    ],
    [
      "if",
      [
        ">",
        "a",
        "cd"
      ],
      [
        "print",
        "demo"
      ],
      [
        "print",
        "not demo"
      ]
    ]
  ],
  [
    "say",
    [
      "print",
      "a",
      [
        "save",
        [
          "b",
          [
            "x",
            [
              "c",
              "8"
            ]
          ]
        ]
      ]
    ]
  ],
  [
    "print",
    "fun"
  ]
]
```

* Line number support

Generated syntax tree contains line numbers:

```cirru
demo
  demo $ demo
```
to (simplied print):
```
  - - text: "demo"
      file: 
        text: "demo\n  demo $ demo"
        path: "./cirru/indent.cirru"
      start: 
        x: 0
        y: 0
      end: 
        x: 3
        y: 0
    - - text: "demo"
        file: 
          text: "demo\n  demo $ demo"
          path: "./cirru/indent.cirru"
        start: 
          x: 2
          y: 1
        end: 
          x: 5
          y: 1
      - - text: "demo"
          file: 
            text: "demo\n  demo $ demo"
            path: "./cirru/indent.cirru"
          start: 
            x: 9
            y: 1
          end: 
            x: 12
            y: 1
```

For further usages, a file object is attached to each token:

```coffee
token =
  text: 'word'
  start: {}
  end: {}
  file:
    path: './code.cirru'
    text: 'content of code.cirru'
```

### Compatibility

`0.5.0` changed the return value structure of `.parse()`
which `cirru-interpreter` depends on.

### License

MIT