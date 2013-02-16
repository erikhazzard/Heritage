#=============================================================================
#
#events
#   global events system, used for communication between systems / components
#   and entities
#
#=============================================================================
define(['lib/backbone', 'lib/underscore'], (Backbone)->
    events = _.extend({}, Backbone.Events)
    return events
)
