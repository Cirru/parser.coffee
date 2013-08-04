
require('calabash').do 'cirru-parser',
  'coffee -o lib/ -wmbc coffee/'
  'node-dev test/demo.coffee test/code.cr'