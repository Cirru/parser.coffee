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
[
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
            "nest"
          ],
          "ok"
        ]
      ],
      "fine",
      [
        "func",
        "more"
      ]
    ],
    "wait"
  ]
]
```

```
result: { code: 
   [ 'print (a b (c d e))',
     '  more indeint',
     '          nest',
     '        ok',
     '    fine',
     '    func more',
     '  wait' ],
  tree: [ [ 'print', [Object], [Object], 'wait', line: 1 ] ] }
```

### Cirru's syntax

* parentheses, indentations, whitespaces are the rules  
* its syntax tree is merely a list of lists and strings  
* it's a simplest, indetation-sensitive syntax

### Usage

```
npm install cirru-parser
```