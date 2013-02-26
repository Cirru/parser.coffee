
## Cirru-parser

### Cirru's syntax

* Indetation-sensitive syntax  
* Blanks seperate words, and words make sense  
* Using inline parentheses  
* No special syntax rules for types or oprerations

For code like this:

```scirpus
let
    a 1
    b 2

  print a b

print x
  do
    a
    a
      b c

while (< x 3)
  if (> x 2)
    do
      console.log x
      += x 1
    console.log false
```

After wrapping with parentheses:

```scheme
(let
    ((a 1)
    (b 2))
  (print a b))
(print x
  (do
    a
    (a
      (b c))))
(while (< x 3)
  (if (> x 2)
    (do
      (console.log x)
      (+= x 1))
    (console.log false)))
```

Parsing result will be:

```json
[
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
  ],
  [
    "print",
    "x",
    [
      "do",
      "a",
      [
        "a",
        [
          "b",
          "c"
        ]
      ]
    ]
  ],
  [
    "while",
    [
      "<",
      "x",
      "3"
    ],
    [
      "if",
      [
        ">",
        "x",
        "2"
      ],
      [
        "do",
        [
          "console.log",
          "x"
        ],
        [
          "+=",
          "x",
          "1"
        ]
      ],
      [
        "console.log",
        "false"
      ]
    ]
  ]
]
```

### Usage

```
npm install cirru-parser
```

Import it in Node, an example in CoffeeScript:  

```coffee
{parse, build, wrap} = require "cirru-parser"
parse "print\n  string a"
# [ [ 'print', [ 'string', 'a' ] ] ]
```

* `wrap` add parentheses for Cirru code  
* `build` build a tree from wrapped code  
* `parse` combines them: `build . wrap`  