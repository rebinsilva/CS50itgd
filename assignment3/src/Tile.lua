--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.shiny = (math.random(100) <= 5)
end

function Tile:render(x, y)
    -- make shiny tile bright by making other tiles dull
    local brightness = 0.7
    if self.shiny then
	brightness = 1
    end

    -- draw shadow
    love.graphics.setColor(brightness*34/255, brightness*32/255, brightness*52/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(brightness*255/255, brightness*255/255, brightness*255/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    
    if self.shiny then
	love.graphics.setColor(0/255, 0/255, 0/255, 128/255)
	love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
	    self.x + x, self.y + y, 0, 1/5, 1/5)
    end
end
