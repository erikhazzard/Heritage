#========================================
#Require Config (load additional libraries)
#========================================
require.config({
    baseUrl: '/static/js',
    urlArgs: "v="+(new Date()).getTime(),
    shim: {
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
    require(['tests/tests'], ()->
        #Start runner
        mocha.run()
    )
)
