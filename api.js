var jsonServer = require('json-server');

var server = jsonServer.create()
server.use(jsonServer.defaults())
server.use(jsonServer.router('db.json'))

console.log('Listening at 4000')
server.listen(4000)
