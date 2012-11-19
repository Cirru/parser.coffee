
echo '---- start watching'
cd `dirname $0`

coffee -o lib/ -wbc src/* &
cd test/
node-dev test.coffee &
doodle box.html &

read

pkill -f coffee
pkill -f node-dev
pkill -f doodle

echo '---- stop watching'
