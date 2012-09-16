
echo '---- start watching'
cd `dirname $0`

coffee -o lib/ -wbc src/* &
node-dev test/test.coffee &

read

pkill -f 'coffee -o lib/ -wbc src/*'
pkill -f 'node-dev/wrapper.js test/test.coffee'

echo '---- stop watching'