#========================================
#Require Config (load additional libraries)
#========================================
requirejs.config({
    baseUrl: '/static/js',
    #For dev
    urlArgs: "v="+(new Date()).getTime(),

    shim: {
        'lib/d3': {
            exports: 'd3'
        },
        'lib/backbone': {
            #These script dependencies should be loaded before loading
            #backbone.js
            deps: ['lib/underscore', 'lib/jquery'],
            #Once loaded, use the global 'Backbone' as the
            #module value.
            exports: 'Backbone'
        }
    }
})

#========================================
#Set everything up
#========================================
require(["jquery", "game"], ($, Game)->
    game = new Game()
    game.start()
    
    if window
        window.game = game
)
