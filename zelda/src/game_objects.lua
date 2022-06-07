--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },
    ['heart'] = {
	type = 'heart',
	texture = 'hearts',
	frame = 5,
	width = 16,
	height = 16,
	solid = false,
        defaultState = 'unconsumed',
        states = {
            ['unconsumed'] = {
                frame = 5
            },
            ['consumed'] = {
                frame = 5
            }
        }
    },
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 111,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'unlifted',
        states = {
            ['unlifted'] = {
                frame = 111
            },
            ['lifted'] = {
                frame = 111
            }
	}
    }
}
