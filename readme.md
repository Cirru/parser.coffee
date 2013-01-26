## Cirru-parser

### Intro

I played some tricks, it's not a complele parser.  
But you can read this to suppose how it works.  

```
print (a b (c d e))
  more indeint
          nest
        ok
    fine
    func more
  wait
```

```json
result: [
  [
    "print",
    [
      "a",
      "b",
      [
        "c",
        "d",
        "e"
      ]
    ],
    [
      "more",
      "indeint",
      [
        [
          [
            [
              "nest"
            ]
          ],
          [
            "ok"
          ]
        ]
      ],
      [
        "fine"
      ],
      [
        "func",
        "more"
      ]
    ],
    [
      "wait"
    ]
  ],
  [
    "table",
    [
      "a",
      "b"
    ],
    [
      "table",
      [
        "a",
        "b"
      ]
    ]
  ]
]
```

```
[ [ 'print',
    [ 'a', 'b', [Object], line: 1 ],
    [ 'more', 'indeint', [Object], [Object], [Object], line: 2 ],
    [ 'wait', line: 7 ],
    line: 1 ],
  [ 'table',
    [ 'a', 'b', line: 9 ],
    [ 'table', [Object], line: 10 ],
    line: 8 ] ]
```

### Cirru's syntax

* parentheses, indentations, whitespaces are the rules  
* its syntax tree is merely a list of lists and strings  
* it's a simplest, indetation-sensitive syntax

### Usage

```
npm install cirru-parser
```