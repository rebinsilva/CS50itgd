--[[
    GD50
    Breakout Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a power up that falls down from the brick durin a random
    hit. Depending on the power up, the power up either brings a new
    ball or unlocks all the locked bricks in the level.
]]

PowerUp = Class{}

function PowerUp:init(x, y, isAnyLocked)
    -- simple positional and dimensional variables
    self.x = x
    self.y = y
    self.width = 6
    self.height = 6

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 16
    self.dx = 0

    -- randomizes the type of power-up
    if isAnyLocked then
	self.skin = math.random(9, 10)
    else
	self.skin = 9
    end
end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:update(dt)
    self.y = self.y + self.dy*dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], 
	gFrames['powerups'][self.skin], self.x, self.y)
end
