--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(difficulty)
    local height = 10
    local width = 100 + 10*difficulty

    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- color of lock and key
    local lockAndKeyID = LOCK_AND_KEYS[math.random(#LOCK_AND_KEYS)]
    local isLock = false
    local isKey = false
    local lockObject = nil
    local flagsetObject = nil
    local flagpostObject = nil

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
	    -- chance to generate lock so that lock will 
	    -- always be in first one-third unless blocked by chasms
	    elseif not isLock and math.random(math.floor(width/3)^4) < x^4 then
		lockObject = GameObject {
                        texture = 'lock_and_keys',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = LOCK_OFFSET + lockAndKeyID,
                        collidable = true,
                        solid = true,
			unlocked = false,
			consumable = false,
			onConsume = function(player, object)
			    gSounds['pickup']:play()
			    player.score = player.score + 100
			    flagpostObject.hide = false
			    flagpostObject.consumable = true
			    flagsetObject.hide = false
			end
                    }
                table.insert(objects, lockObject)
		isLock = true
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
	    if not isKey and x > width/3 and math.random(math.floor(width/3)^4) < (x-width/3)^4 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a key if we haven't already hit the block
                            if not obj.hit then

				-- maintain reference so we can set it to nil
				local gem = GameObject {
				    texture = 'lock_and_keys',
				    x = (x - 1) * TILE_SIZE,
				    y = (blockHeight - 1) * TILE_SIZE - 4,
				    width = 16,
				    height = 16,
				    frame = lockAndKeyID,
				    collidable = true,
				    consumable = true,
				    solid = false,

				    -- gem has its own function to add to the player's score
				    onConsume = function(player, object)
					gSounds['pickup']:play()
					lockObject.consumable = true 
					lockObject.solid = false
				    end
				}
				
				-- make the gem move up from the block and play a sound
				Timer.tween(0.1, {
				    [gem] = {y = (blockHeight - 2) * TILE_SIZE}
				})
				gSounds['powerup-reveal']:play()

				table.insert(objects, gem)
			    end

			    obj.hit = true

                            gSounds['empty-block']:play()
                        end
                    }
                )
		isKey = true
            elseif math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
	end
    end

    for x = width+1, width+GOAL_PLATFORM do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end


	tileID = TILE_ID_GROUND

	for y = 7, height do
	    table.insert(tiles[y],
		Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
	end

    end

    local x = width+math.ceil(GOAL_PLATFORM/2)

    flagpostObject = 
	GameObject {
	    texture = 'flagposts',
	    x = (x - 1) * TILE_SIZE,
	    y = (6 - 3) * TILE_SIZE,
	    width = 16,
	    height = 48,
	    frame = math.random(6),
	    collidable = false,
	    hide=true,
	    onConsume = function(player, object)
		gSounds['pickup']:play()
		gStateMachine:change('play', {difficulty = difficulty+1, score = player.score})
	    end
	}
    table.insert(objects, flagpostObject)
    local flagColor = FLAGS[math.random(#FLAGS)]
    local flagAnimation = Animation {frames = {flagColor, flagColor+1}, interval = 0.5}
    flagsetObject =
	GameObject {
	    texture = 'flagsets',
	    x = (x - 1) * (TILE_SIZE) + math.floor((TILE_SIZE)/2),
	    y = (6 - 3) * TILE_SIZE,
	    width = 16,
	    height = 16,
	    collidable = false,
	    animation = flagAnimation,
	    hide=true,
	    consumable = false,
	}
    table.insert(objects, flagsetObject)

    local map = TileMap(width+GOAL_PLATFORM, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end