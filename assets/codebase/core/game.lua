Game = class("Game")


function Game:initialize()
    self.fonts = {}
    self.font = self:setFont(15)

    self.dragging = false

    self.hud = Hud:new()

    dealer = Dealer:new()
    player = Player:new()
end

function Game:update(dt)
    dealer:update(dt)
    player:update(dt)
end

function Game:draw()

    dealer:draw()

    self.hud:draw()
end

function Game:keypressed(key)

end

function Game:mousepressed(x, y, button)
    self.hud:mousepressed(x, y, button)
    dealer:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
    self.hud:mousereleased(x, y, button)
end

function Game:setFont(size)
    if not self.fonts[size] then 
        self.fonts[size] = love.graphics.newFont("assets/gfx/font/pixelmix.ttf", size)
    end

    self.font = self.fonts[size]
    
    love.graphics.setFont(self.fonts[size])
end
