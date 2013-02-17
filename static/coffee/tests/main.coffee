#========================================
#Require Config (load additional libraries)
#========================================
require.config({
    baseUrl: '/static/js',
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
#Setup tests
#========================================
require(['require', 'lib/chai', 'lib/mocha'], (require,chai)->
    assert = chai.assert
    should = chai.should()
    expect = chai.expect

    mocha.setup('bdd')

    #Tests go here
    require(['tests/entity',
        'tests/entities',
        'tests/components/world',
        'tests/components/vector',
        'tests/components/position',
        'tests/components/physics',
        'tests/components/randomWalker',
        'tests/components/flocking',
        
        'tests/systems/physics',
        'tests/systems/spawner',
        ], ()->
        #Start runner
        mocha.run()
    )
)
