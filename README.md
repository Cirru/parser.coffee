
Cirru Parser
------

Cirru is an indentation-based grammar.
You may use it to create your own DSLs or scripting languages.

The latest parser is written in Go, you may check out [here][go].

[go]: https://github.com/Cirru/parser

### Usage

```
npm install --save cirru-parser
```

```coffee
{parse, pare, caution} = require 'cirru-parser'

syntaxTree = parse code, filename
simplifiedTree = pare code, filename

info = caution char
```

* `parse(code, filename)`:

Parse `code` in Cirru grammar, `filename` is optional:

A token in `syntaxTree` is like:

```coffee
token =
  text: 'get'
  x: 0
  y: 0
  $x: 1
  $y: 1
  path: 'a.cirru'
```

And expressions here are just tokens in arrays, like:

```coffee
expression = [
  token
,
  [
    token
  ,
    [
      token
    ]
  ]
]
```

* `pare(code, filename)`:

`pare` is short for `parse`, `filename` is optional.

`simplifiedTree` does not contain informations of files,
like line numbers, file content, which are needed in `caution`.

A token from `pare` is a string, i.e. the `text` field of parsing results.

* `caution(char)`:

`caution` is for generating messages of the location that throws error.
`char` is a sub class of `class Char` defined at `coffee/char.coffee`.

### Live demo

Demo: http://repo.cirru.org/parser/ .
By typing on the left you should see the `pare` results on the right.

### Grammar

Detailed examples can be found in [`cirru/`][cirru] and [`ast/`][ast] directories.

[cirru]: https://github.com/Cirru/cirru-parser/tree/master/cirru
[ast]: https://github.com/Cirru/cirru-parser/tree/master/ast

For short, there are then rules of Cirru:

* It indents with 2 spaces
* Parentheses are closed in the same line it opened
* Strings are quoted with double quotes: `"string"`
* `$` folds followed tokens in an expression
* `,` unfolds followed tokens in an expression

### Parsing

It can be divided into several steps:

* Define main process and export methods: `parser.coffee`
* Wrap code into classes: `line.coffee char.coffee`
* Parse indentations: `tree.coffee`
* Tokenize inline code: `tokenize.coffee token.coffee`
* Resolve `$` and `,` in tree: `expr.coffee`

In the [parser written in Go][go], there's a new solution, you may [check it][sf].

[sf]: http://blog.segmentfault.com/jiyinyiyong/1190000000636303

### Development

Run tests:

```
./make.coffee test
```

To run a specified test, edit parameter in `target.run` and:

```
./make.coffee run
```

Also you may debug `index.html` in a browser after compiling the code:

```
./make.coffee compile
./make.coffee watch
```

### Changelog

#### `0.9`

* changed `inspect` to `caution` to fix error
* changed syntax tree(`.parse`) format

#### `0.8`

* prefer `pare` to `parseShort`.
* add `inspect`

`0.5` changed the `parseShort` API.

### License

MIT
