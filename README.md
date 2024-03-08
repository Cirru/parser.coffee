
Cirru Parser
------

Cirru is an indentation-based grammar.
You may use it to create your own DSLs or scripting languages.

Demo http://repo.cirru.org/parser.coffee

Find more at http://cirru.org/

### Usage

![](https://img.shields.io/npm/v/cirru-parser.svg)

```bash
npm install --save cirru-parser
```

```coffee
{parse, pare} = require 'cirru-parser'

syntaxTree = parse 'code', 'filename' # [{text: 'code', x: 0, y:0, ex: 4, ey: 1}]
simplifiedTree = pare 'code', 'filename' # ['code']
```

* `parse(code, filename)`:

Parse `code` in Cirru grammar, `filename` is optional:

A token in `syntaxTree` is like:

```coffee
token =
  text: 'get'
  x: 0
  y: 0
  ex: 3
  ey: 3
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

### Live demo

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

Here's a Gist showing how it's parsed(not including the steps solving `$` and `,`):

https://gist.github.com/tiye/bdda3f616ff0f1bea917

This method was developed in [the Go version][go], you may [check it out here][sf].

[sf]: http://blog.segmentfault.com/jiyinyiyong/1190000000636303

### Development

Run tests:

```
cirru-script test.cirru
```

Write code:

```bash
yarn
yarn watch
# view generated index.html in a web server
```

Read more details https://github.com/mvc-works/cirruscript-workflow

### Changelog

#### 0.10.1

* switch to `ex, ey` from `$x, $y`

#### 0.10.0

* Rewritten with new solution from Go
* drop caution

### License

MIT
