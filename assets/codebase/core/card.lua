Card = class("Card")

function Card:initialize(rank, suit)
    self.x = 0
    self.y = 0

    self.targetX = 0
    self.targetY = 0
    self.lerpSpeed = 16

    self.width = 2.5  * 30
    self.height = 3.5 * 30

    self.rank = rank or 1
    self.suit = suit or 1

end

function Card:update(dt)
    self:drag(dt)


end

function Card:draw()
    game:setFont(20)
    love.graphics.setColor(1,1,1)

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    
    
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.rank, self.x + 1, self.y + 1)
end


function Card:drag(dt)
    local x, y = love.mouse.getPosition()

    if self.dragging then 
        self.targetX = x
        self.targetY = y
        self.lerpSpeed = 16
    end

    if not love.mouse.isDown(1) then
        game.dragging = false
        self.dragging = false        
        self.lerpSpeed = 6
    end 

    self.x = lerp(self.x, self.targetX - self.width / 2, self.lerpSpeed * dt) 
    self.y = lerp(self.y, self.targetY - self.width / 2, self.lerpSpeed * dt)
end

function Card:mousepressed(x, y, button)
    if pointInRect({x, y}, {self.x, self.y, self.width, self.height}) then 
        if button == 1 and not game.dragging then
            game.dragging = true
            self.dragging = true
        end
    end

    if self.dragging and not button == 1 then 
        game.dragging = false
        self.dragging = false
    end
end

function Card:setPosition(x, y)
    self.x = x
    self.y = y
end

function Card:setTarget(x, y)
    self.targetX = x
    self.targetY = y
end

function Card:getValue()
    if self.rank > 10 then 
        return 10
    end
    return self.rank
end 