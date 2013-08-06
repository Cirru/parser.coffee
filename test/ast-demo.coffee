
{protos} = require '../coffee/states'
ast = protos.ast.new()

print = (args...) -> console.log args...

print ast.tree

ast.push 1
ast.nest()
ast.push 2
ast.nest()
ast.push 3
ast.ease()
ast.push 4
ast.nest()
ast.push 6
ast.nest()
ast.push 7
ast.ease()
ast.push 5

print JSON.stringify ast.tree