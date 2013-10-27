
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
parse :: String, String -> Array[]
tree = parse (content, filename)
```

* info:

For generating hints based on the format of AST leafs.

```
Option =
  text :: String
  x :: Number
  y :: Number
  file:
    text :: String
    path :: String
info :: Option, String -> String
info_hints = info options, "a info demo"
```

`info` is a piece of text to display:

```
a demo info
./cirru/indent.cr : 7
say $ print a
            ^
```

* compact

When set `true`, each leaf of the AST tree becomes string,
when `false`, each leaf is an object with `text x y file`.

```
parse.compact :: Boolean
parse.compact = true
```

#### In Node

```
npm install --save cirru-parser
```
``` coffee
{parse, info} = require 'cirru-parser'
ast = parse './file_path.cr'

parse.compact = no

options =
  text: 'demo of token'
  x: 1
  y: 3
  file:
    text: 'content of file'
    path: 'relative path of file'
info options, "a demo of info"
```

#### In Browser

Add `parser.js` your HTML, or get it with Bower:

```
bower install --save cirru-parser
```

```coffee
window.cirru # object
cirru.parse
cirru.info
cirru.parse.compact = yes
```

It could be also used with RequireJS.

```coffee
define (require, exports) ->
  {parse, info} = require("../bower_components/cirru-parser/parser")
```

### Live demo

Visit (tested on Chrome): http://jiyinyiyong.github.io/cirru-parser/  
By typing at right you should see the code updates

### Syntax

* Lines

Mutiple lines:

```
line 1
line 2
line-3
line 4
```
to
```
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

```
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

```

a b c d
"a b c d"
"a b \" c d"
```
to
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

```
a
  b
    c
e f
    g
  h
```
to
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

```
a $

b $ c

d $ e
  f

g $ h
  i j $ k $
```
to
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

### A glance of Cirru

Combine the syntax rules above:

```

define a (read cd)
  if (> a cd)
    print "demo"
    print "not demo"

say $ print a
  save $ b
    x $ c 8

print "fun"
```
to
```json
[
  [],
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

```

demo
  demo $ demo
```
to
```json
[
  [],
  [
    {
      "text": "demo",
      "x": 4,
      "y": 1
    },
    [
      {
        "text": "demo",
        "x": 6,
        "y": 2
      },
      [
        {
          "text": "demo",
          "x": 13,
          "y": 2
        }
      ]
    ]
  ]
]
```

For further usages, a file object is attached to each token:

```
token =
  text: 'word'
  x: 0
  y: 0
  file:
    path: './code.cr'
    text: 'content of code.cr'
```

### Compatibility

`0.5.0` changed the return value structure of `.parse()`
which `cirru-interpreter` depends on.

### License

MIT