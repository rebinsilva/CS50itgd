--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
    self.dungeon = dungeon
    self.entity = player

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    local pot_index = nil
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
	for k, object in pairs(self.dungeon.currentRoom.objects) do
	    if object.type == 'pot' then
		if self.entity.direction == 'right' and self.entity.x <= object.x and self.entity.x + self.entity.width >= object.x then
		    pot_index = k
		    self.entity:changeState('lift-pot', {pot=object})
		    break
		elseif self.entity.direction == 'left' and self.entity.x <= object.x + object.width and self.entity.x + self.entity.width >= object.x + object.width then
		    pot_index = k
		    self.entity:changeState('lift-pot', {pot=object})
		    break
		elseif self.entity.direction == 'down' and self.entity.y <= object.y and self.entity.y + self.entity.height >= object.y then
		    pot_index = k
		    self.entity:changeState('lift-pot', {pot=object})
		    break
		elseif self.entity.direction == 'up' and self.entity.y <= object.y + object.height and self.entity.y + self.entity.height >= object.y + object.height then
		    pot_index = k
		    self.entity:changeState('lift-pot', {pot=object})
		    break
		end
	    end
	end
	if pot_index then
	    table.remove(self.dungeon.currentRoom.objects, pot_index)
	end
    end
end
