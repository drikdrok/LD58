BetAdjuster = class("BetAdjuster")

function BetAdjuster:initialize(denomination, x, y)

    self.denomination = denomination

    self.counter = 0

    self.x = x
    self.y = y

    self.width = 75

    self.increaseButton = Button:new(self.x, self.y, self.width, self.width, "+", function()
        local change = 1
        if love.keyboard.isDown("lshift") then 
            change = 5
        end
        player:changeBet(self.denomination * change)
    end)

    self.decreaseButton = Button:new(self.x, self.y + self.width + 5, self.width, self.width, "-", function()
        local change = 1
        if love.keyboard.isDown("lshift") then 
            change = 5
        end
        self.counter = self.counter - change
        if self.counter < 0 then self.counter = 0 end
        player:changeBet(-self.denomination * change)
    end)

    self.increaseButton.enabled = true
    self.decreaseButton.enabled = true
end

function BetAdjuster:draw()
    game:setFont(20)
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.denomination, self.x + self.width / 2 - game.font:getWidth(self.denomination) / 2, self.y - 40)

    self.increaseButton:draw()
    self.decreaseButton:draw()
end

function BetAdjuster:setActive(value)
    self.increaseButton.enabled = value
    self.decreaseButton.enabled = value
end

function BetAdjuster:mousepressed(x,y, button)
    self.increaseButton:mousepressed(x, y, button)
    self.decreaseButton:mousepressed(x,y, button)
end

function BetAdjuster:mousereleased(x,y, button)
    self.increaseButton:mousereleased(x, y, button)
    self.decreaseButton:mousereleased(x,y, button)
end