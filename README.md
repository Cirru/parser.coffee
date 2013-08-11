
Cirru Parser
------

### Usage

```
npm install --save cirru-parser
```
``` coffee
{parse, error} = require 'cirru-parser'
ast = parse './file_path.cr'
ast.tree # AST tree, always has, check ast.errors first
ast.errors # array of errors if there are, or `[]` by default

options =
  text: 'demo of token'
  x: 1
  y: 3
  file:
    text: 'content of file'
    path: 'relative path of file'
 error options # an API for putting errors
```

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
  [],
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

* Code is data

In Cirru, variables are strings, so the parser doesn't have to tell.

### Error messages

* Quote not closed

This could occur when `"` is not closed at line end, or file end.

* Bracket not match

When too many `)` or too many `(` appears, it gives errors.

* demo here:

```

1 (3

2)

"ddd
```
has errors:
```

✗ ./test/piece.cr: 2
1 (3
   ^ bracket not closed


✗ ./test/piece.cr: 4
2)
 ^ too many close bracket


✗ ./test/piece.cr: 6
"ddd
   ^ quote at end

```

### Known issue

* `[]` generated unexpectedly when first line empty
* Reviewed but not well tested

### License

MIT