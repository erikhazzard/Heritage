define([], ()->
    Socket = io.connect('http://localhost:1337')
    
    return Socket
)
