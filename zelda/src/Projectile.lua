--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(def, x, y)

    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- projectile info
    local direction = def.direction
    if direction == 'left' then
	self.speed = {-def.speed, 0}
    elseif direction == 'right' then
	self.speed = {def.speed, 0}
    elseif direction == 'up' then
	self.speed = {0, -def.speed}
    else
	self.speed = {0, def.speed}
    end
    startingPoint = {x, y}
    self.travelled = 0

    -- default empty collision callback
    self.onCollide = function() end
end

function Projectile:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Projectile:update(dt)
    self.x = self.x + self.speed[1]*dt
    self.y = self.y + self.speed[2]*dt
    self.travelled = self.travelled + (self.speed[1]+self.speed[2])*dt
    
    if self.travelled > 4*TILE_SIZE then
	self.dead = true
    end

    if self.x - MAP_RENDER_OFFSET_X< TILE_SIZE/2 or self.x - MAP_RENDER_OFFSET_X + self.width > TILE_SIZE*(MAP_WIDTH - 1/2) or self.y - MAP_RENDER_OFFSET_Y < TILE_SIZE or self.y -MAP_RENDER_OFFSET_Y + self.height > TILE_SIZE*(MAP_HEIGHT - 1/2) then
	self.dead = true
    end
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states and self.states[self.state] and self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end
