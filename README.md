
Cirru Parser
------

Cirru is a indentation based grammer for simplicity.
You may use it to DIY DSLs or scripting languages.

It not designed for tough programming tasks,
but for small ones where people want to make coding fun.

### Usage

* parse:

Parse `code` in Cirru grammar, `filename` is optional:

```
npm install --save cirru-parser
```

```coffee
{parse, pare} = require 'cirru-parser'

syntaxTree = parse code, filename
simplifiedTree = pare code, filename
```

`syntaxTree` is a class-based representation of Cirru's syntax tree.
An example is like:

```
[
  Exp [
    Token
    Exp [
      Exp [
        Token
        Token
      ]
      Token
    ]
  ]
]
```

For learning the methods and preperties, please read source code.

### Live demo

Visit (tested on Chrome): http://repo.cirru.org/parser/ .
By typing at left you should see the code updates

### Grammar

Detailed examples can be found in `cirru/` and `ast/` directories.

For short, there are several rules of Cirru:

* It's based on indentations of 2 spaces
* Parentheses are opened and closed in the same line
* Strings are quoted with `"string"`
* `$` folds code after in its expression
* `,` unfolds code that after in its expression

### Changelog

`0.8` prefer `pare` to `parseShort`.

`0.5` changed the `parseShort` API.

### License

MIT