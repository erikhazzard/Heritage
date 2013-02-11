define(['entity'], (Entity)->
    Game = {}
    Game.init = ()->
        @a = new Entity()
    
    return Game
)
