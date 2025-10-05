Game = class("Game")


function Game:initialize()
    self.fonts = {}
    self.font = self:setFont(15)

    self.dragging = false

    self.hud = Hud:new()

    self.hasClicked = false

    self:newGame()
end

function Game:load()
    self.loaded = true
    self.hud:setMakeBets(true)

end

function Game:update(dt)
    if not self.loaded then 
        self:load()
    end
    tooltip:update(dt)
    dealer:update(dt)
    player:update(dt)

    self.hud:update(dt)

    shop:update(dt)

end

function Game:draw()
    dealer:draw()

    self.hud:draw()

    shop:draw()

    tooltip:draw()

    if self.state == "death" then 



    end
end

function Game:keypressed(key)

end

function Game:mousepressed(x, y, button)
    self.hasClicked = false
    self.hud:mousepressed(x, y, button)
    dealer:mousepressed(x, y, button)

    shop:mousepressed(x, y, button)

    if not self.hasClicked then 
        deckViewer:mousepressed(x, y, button)
    end
end

function Game:mousereleased(x, y, button)
    self.hud:mousereleased(x, y, button)
    shop:mousereleased(x, y, button)
    deckViewer:mousereleased(x, y, button)
end

function Game:setFont(size)
    if not self.fonts[size] then 
        self.fonts[size] = love.graphics.newFont("assets/gfx/font/pixelmix.ttf", size)
    end

    self.font = self.fonts[size]
    
    love.graphics.setFont(self.fonts[size])
end


function Game:newGame()
    dealer = Dealer:new()
    player = Player:new()
    deckViewer = DeckViewer:new()
    shop = Shop:new()
    tooltip = Tooltip:new()
    self.state = "playing"
    self.loaded = false
end