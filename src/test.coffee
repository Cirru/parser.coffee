
import fs from "fs"
import chalk from "chalk"
import * as parser from "./parser"

names = [
  , "demo"
  , "folding"
  , "indent"
  , "line"
  , "parentheses"
  , "quote"
  , "unfolding"
  , "html"
  , "spaces"
  , "comma"
]

test = (file) ->

  filename = "cirru/" + file + ".cirru"
  content = fs.readFileSync ("ast/" + file + ".json"), "utf8"
  wanting = content.trim()

  ast = parser.pare (fs.readFileSync filename, "utf8"), filename
  ast = JSON.stringify ast, null, 2

  if ast == wanting
    console.log (chalk.gray ":ok! fine with:", file)
  else
    console.log (chalk.red ":failed! with file:", file)
    console.log ast

names.forEach test
