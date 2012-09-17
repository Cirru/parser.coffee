
echo '---- start watching'
cd `dirname $0`

coffee -o lib/ -wbc src/* &
cd test/
node-dev test.coffee &

read

pkill -f 'coffee -o lib/ -wbc src/*'
pkill -f 'node-dev/wrapper.js test/test.coffee'

echo '---- stop watching'
