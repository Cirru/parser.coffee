## Cirru-parser

### Intro

I played some tricks, it's not a complele parser.  
But you can read this to suppose how it works.  

```
print (string (hell]"o) world)

print
  string hello world

data
  a b
    a b
      b b

data
      bet ok
    x y
  x y
  z
```

```json
{ code: 
   [ 'print (string (hell]"o) world)',
     '',
     'print',
     '  string hello world',
     '',
     'data',
     '  a b',
     '    a b',
     '      b b',
     '',
     'data',
     '      bet ok',
     '    x y',
     '  x y',
     '  z' ],
  ast: 
   [ [ 'print', [Object], line: 1 ],
     [ line: 2 ],
     [ 'print', [Object], line: 3 ],
     [ line: 5 ],
     [ 'data', [Object], line: 6 ],
     [ line: 10 ],
     [ 'data', [Object], [Object], [Object], line: 11 ] ] }
```

### Cirru's syntax

* parentheses, indentations, whitespaces are the rules  
* its syntax tree is merely a list of lists and strings  
* it's a simplest, indetation-sensitive syntax

### Usage

```
npm install cirru-parser
```