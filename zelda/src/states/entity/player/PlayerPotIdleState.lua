--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:init(player, dungeon)
    self.dungeon = dungeon
    self.entity = player

    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function PlayerPotIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.pot = params.pot
end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk-pot', {pot=self.pot})
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
	local def = GAME_OBJECT_DEFS['pot']
	def['speed'] = 50
	def['direction'] = self.entity.direction
	local projectile = Projectile(def, self.pot.x, self.pot.y)
	projectile.onCollide = function(entity)
	    entity:damage(1)
	end
	table.insert(self.dungeon.currentRoom.projectiles, projectile)
        self.entity:changeState('idle')
    end
end

function PlayerPotIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    love.graphics.setColor(1, 1, 1, 192/255)
    love.graphics.draw(gTextures[self.pot.texture], gFrames[self.pot.texture][self.pot.frame],
        self.pot.x, self.pot.y)
    love.graphics.setColor(1, 1, 1, 1)
end
