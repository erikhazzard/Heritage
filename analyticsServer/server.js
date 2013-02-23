//Global vars
var io = require('socket.io').listen(1337),
    Backbone = require('backbone'),
    _ = require('underscore'),
    mongo = require('mongodb').Db,
    Server = require('mongodb').Server;

//Set SocketIO Log level (TODO: Use winston)
io.set('log level', 1);
var db = new mongo('legacy', new Server('127.0.0.1', 27017, {}), {w:0});
var logCollection = null;

db.open(function(err, targetDb){
    console.log('Connected');
    db.collection('log', function(err, collection){
        logCollection = collection;    
    });
});


//----------------------------------------------------------------------------
//
//Socket setup
//
//----------------------------------------------------------------------------
var events = _.extend({}, Backbone.Events);

//============================================================================
//Socket IO / Redis
//============================================================================
io.sockets.on('connection', function (socket) {
    var ticks = 0;
    //When client sends over data
    socket.on('logData', function(data){
        //insert something
        logCollection.insert(data, function(err, bla){
            console.log('sending', socket.id);
            //events.trigger('logUpdated'); 
        });
    });
    
    //when data is changed, force a socket emit event
    //-----------------------------------
    var sendData = function(){
        logCollection.find().toArray(function(err, results){
            console.log('sending', socket.id);
            socket.emit('returnedLogData', results);
        });
    };
    
    events.on('logUpdated', sendData);
    //send data to the socket whenever data changes
    //give data to client when they ask
    socket.on('getLogData', sendData);

    //When the client disconnects, close the subscription
    socket.on('disconnect', function(){
        events.off('logUpdated');
        io.sockets.emit('user disconnected');
    });
});
