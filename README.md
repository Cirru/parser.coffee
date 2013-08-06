
Cirru Parser
------

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

* Double quote and escape

String wrapped with `"`. Single quote is only text.

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
]```

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

### Folding indetation

`$` is used in reducing indetations:

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

With the syntaxes described above, I got Cirru:

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


### Known issue

* `[]` generated when first line empty.
* No detailed error messages

### License

MIT