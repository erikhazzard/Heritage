define([], ()->
    try
        Socket = io.connect('http://localhost:1337')
    catch err
        Socket = null
    
    return Socket
)
