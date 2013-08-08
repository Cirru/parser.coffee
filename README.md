
Cirru Parser
------

### Usage

```
npm install --save cirru-parser
```
``` coffee
ret = require('cirru-parser').parse('file_path').ast
# ret.ast.tree # AST tree
# ret.ast.errors # array of errors if there are
# ret.error # an API for putting errors
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

"ddd
```
has errors:
```
1 (3
~~~^~~~~~
@ line 2: bracket not closed

"ddd
~~~^~~~~~
@ line 4: quote at end
```

### Known issue

* `[]` generated unexpectedly when first line empty
* No detailed error messages when syntax gets wrong
* Not well tested or reviewed, not available to use now

### License

MIT