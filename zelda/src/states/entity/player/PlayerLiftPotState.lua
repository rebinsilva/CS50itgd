--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 8

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    -- pot-left, pot-up, etc
    self.player:changeAnimation('pot-' .. self.player.direction)
end

function PlayerLiftPotState:enter(params)

    -- restart pot swing sound for rapid swinging
    gSounds['pot']:stop()
    gSounds['pot']:play()

    -- restart pot swing animation
    self.player.currentAnimation:refresh()

    -- set associated pot
    self.pot = params['pot']
    
    self.pot.x = self.player.x
    self.pot.y = self.player.y
    Timer.tween(1, {
        [self.pot] = {x = self.x, y = self.y},
    })
end

function PlayerLiftPotState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-pot', {pot=self.pot})
    end

    -- allow us to change into this state afresh if we swing within it, rapid swinging
    if love.keyboard.wasPressed('enter') then
        self.player:changeState('throw-pot')
    end
end

function PlayerLiftPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    love.graphics.setColor(1, 1, 1, 192/255)
    love.graphics.draw(gTextures[self.pot.texture], gFrames[self.pot.texture][self.pot.frame],
        self.pot.x, self.pot.y)
    love.graphics.setColor(1, 1, 1, 1)
    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
