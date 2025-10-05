FloatingText = class("FloatingText")

function FloatingText:initialize(text, x, y)
    self.x = x
    self.y = y
    self.text = text

    self.speed = 50
    self.opacity = 1
    
    self.timer = 0

    game.hud.floatingTexts[self] = self
end

function FloatingText:update(dt)
    self.timer = self.timer + dt


    self.y = self.y + (math.sin(self.timer *3 ) * 25*dt)
end 

function FloatingText:draw()
    love.graphics.setColor(1,1,1, self.opacity)
    game:setFont(24)
    love.graphics.print(self.text, self.x, self.y)
end 