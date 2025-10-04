Hand = class("Hand")

function Hand:initialize(x, y)
    self.cards = {}

    self.x = x
    self.y = y

    self.targetX = x
    self.targetY = y

    self.showSum = false

    self.lerpSpeed = 20
end

function Hand:update(dt)
    
    self.x = lerp(self.x, self.targetX, self.lerpSpeed * dt) 
    self.y = lerp(self.y, self.targetY, self.lerpSpeed * dt)
    
    
    for i,v in pairs(self.cards) do
        v:setTarget(self.x, v.targetY)
        v:update(dt)
    end
end

function Hand:draw(dt)
    for i,v in pairs(self.cards) do
        v:draw()
    end

    if self.showSum then 
        game:setFont(16)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(self:getSum(), self.x - game.font:getWidth(self:getSum()) / 2, self.y - (#self.cards-1) * 120 - 60)
    end
end

function Hand:mousepressed(x, y, button)
    for i,v in pairs(self.cards) do
        v:mousepressed(x, y, button)
    end
end

function Hand:addCard(card)
    card:setTarget(self.x, self.y - #self.cards * 120)
    table.insert(self.cards, card)
end

function Hand:removeCard(index)
    if not self.cards[index] then return end
    table.remove(self.cards, index)
end

function Hand:getSum()
    local sum = 0
    for i,card in pairs(self.cards) do 
        local value = card:getValue()
        if value == 1 then -- Ace can be 11 or 1
            if sum + 11 > 21 then 
                sum = sum + 1
            else
                sum = sum + 1
            end
        else
            sum = sum + value
        end
    end 

    return sum
end


function Hand:setTarget(x, y)
    self.targetX = x
    self.targetY = y
end







-- Dealer Hand

DealerHand = class("DealerHand", Hand)

function DealerHand:initialize()
    Hand.initialize(self, 1920 / 2 - 200, 100)
end

function DealerHand:addCard(card)
    card:setTarget(self.x + #self.cards * 125, self.y )
    table.insert(self.cards, card)
end

function DealerHand:update(dt)
    for i,v in pairs(self.cards) do
        v:update(dt)
    end
end
