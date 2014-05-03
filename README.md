
Cirru Parser
------

Cirru is a indentation-based grammer.
You may use it to roll out your own DSLs or scripting languages.

### Usage

```
npm install --save cirru-parser
```

```coffee
{parse, pare, inspect} = require 'cirru-parser'

syntaxTree = parse code, filename
simplifiedTree = pare code, filename

info = inspect char
```

* `parse`:

Parse `code` in Cirru grammar, `filename` is optional:


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

Go to [`coffee/`][coffee] and read `char.coffee` and `exp.coffee` if you need details.


[coffee]: https://github.com/Cirru/cirru-parser/tree/master/coffee


* `pare`:

`pare` of short for `parse`, `filename` is optional.


`simplifiedTree` does not contain informations,
like line number, file content, that may be needed in inspecting.

* `inspect`

`inspect` is for generating message about the location that throws error.
`char` is a sub class of `class Char` defined at `coffee/char.coffee`.

### Live demo

Demo: http://repo.cirru.org/parser/ .
By typing on the left you should see the `pare` results on the right.

### Grammar

Detailed examples can be found in [`cirru/`][cirru] and [`ast/`][ast] directories.

[cirru]: https://github.com/Cirru/cirru-parser/tree/master/cirru
[ast]: https://github.com/Cirru/cirru-parser/tree/master/ast

For short, there are several rules of Cirru:

* It's based on indentations of 2 spaces
* Parentheses are opened and closed in the same line
* Strings are quoted with `"string"`
* `$` folds code after in its expression
* `,` unfolds code that after in its expression

### Parsing

It is divided into several steps:

* Define main process and export methods: `parser.coffee`
* Wrap code into classes: `line.coffee char.coffee`
* Parse indentations: `tree.coffee`
* Tokenize inline code: `tokenize.coffee token.coffee`
* Resolve `$` and `,` in tree: `exp.coffee`

### Development

Run tests:

```
./make.coffee test
```

To run a specifiedd test, edit parameter in `target.run` and:

```
./make.coffee run
```

Also you may open `index.html` and debug in a web page,
but compile and watch the code first:

```
./make.coffee compile
./make.coffee watch
```

### Changelog

`0.8` prefer `pare` to `parseShort`.

`0.5` changed the `parseShort` API.

### License

MIT
