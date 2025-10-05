Hand = class("Hand")

function Hand:initialize(x, y)
    self.cards = {}

    self.x = x
    self.y = y

    self.targetX = x
    self.targetY = y

    self.showSum = true

    self.betAmount = 100
    self.winMultiplier = 1

    self.lerpSpeed = 20

    self.statusText = nil

end

function Hand:update(dt)
    
    if math.abs(self.targetX - self.x) <= 1 and math.abs(self.targetY - self.y) <= 1 then 
        self.x = self.targetX
        self.y = self.targetY
    else
        self.x = lerp(self.x, self.targetX, self.lerpSpeed * dt) 
        self.y = lerp(self.y, self.targetY, self.lerpSpeed * dt)
        for i,v in pairs(self.cards) do
            v:setTarget(self.x, v.targetY)
        end
    end
    
    for i,v in pairs(self.cards) do
        v:update(dt)
    end
end

function Hand:draw(dt)
    for i,v in pairs(self.cards) do
        v:draw()
    end

    if self.showSum then 
        self:drawInfo()
    end
end

function Hand:mousepressed(x, y, button)
    for i,v in pairs(self.cards) do
        v:mousepressed(x, y, button)
    end
end

function Hand:addCard(card)
    card:setTarget(self.x, self.y - #self.cards * 160)
    table.insert(self.cards, card)
end

function Hand:removeCard(index)
    if not self.cards[index] then return end
    table.remove(self.cards, index)
end

function Hand:getSum()
    local sum = 0
    table.sort(self.cards, function (a,b) 
        return a.rank < b.rank
    end)
    for i,card in pairs(self.cards) do 
        local value = card:getValue()
        if card.flipped then value = 0 end
        if value == 1 then -- Ace can be 11 or 1
            if sum + 11 > 21 then 
                sum = sum + 1
            else
                sum = sum + 11
            end
        else
            sum = sum + value
        end
    end 

    return sum
end

function Hand:isBlackjack()
    if #self.cards == 2 then 
        return (self.cards[1].rank == 1 and self.cards[2].rank >= 10) or (self.cards[1].rank >= 10 and self.cards[2].rank == 1)
    end
    return false
end

function Hand:drawInfo()
    game:setFont(16)
    love.graphics.setColor(1,1,1,1)
    local text = self:getSum()
    if self.statusText then 
        text = text .. ": " .. self.statusText
    end
    love.graphics.print(text, self.x - game.font:getWidth(text) / 2, self.y  + 110)
    love.graphics.print("$" .. self.betAmount, self.x - game.font:getWidth("$" .. self.betAmount) / 2, self.y + 140 )
end


function Hand:setTarget(x, y)
    self.targetX = x
    self.targetY = y
end

function Hand:collect()
    for i,v in pairs(self.cards) do
        v:setTarget(dealer.drawDeckX, dealer.drawDeckY)
    end
end

function Hand:onScore()
    for i,card in pairs(self.cards) do
        for j, enchantment in pairs(card.enchantments) do
            enchantment:onScore(self)
        end
    end
end

function Hand:onBlackjack()
     for i,card in pairs(self.cards) do
        for j, enchantment in pairs(card.enchantments) do
            enchantment:onBlackjack(self)
        end
    end
end

function Hand:onPush()
    if self:hasEnchantment(WinPushEnchantment) then 
        self:winHand()
    end
end

function Hand:hasEnchantment(enchantmentClass)
    for i,v in pairs(self.cards) do
        if v:hasEnchantment(enchantmentClass) then 
            return true
        end
    end
    return false
end


function Hand:winHand()
    local win = self.betAmount * self.winMultiplier 
    player:addBalance(win)
    player:addBalance(self.betAmount)
    
    FloatingText:new("+$"..win, self.x - cardWidth / 2, self.y - #self.cards * cardHeight + 30)
    
end

function Hand:setFlipped(value)
    for i,v in pairs(self.cards) do 
        v.flipped = value
    end
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

function DealerHand:drawInfo()
    game:setFont(16)
    love.graphics.setColor(1,1,1,1)
    local text = self:getSum()
    if self.statusText then 
        text = text .. ": " .. self.statusText
    end
    love.graphics.print(text, 1920 / 2 -  game.font:getWidth(text) / 2, self.y  + 120)
end
