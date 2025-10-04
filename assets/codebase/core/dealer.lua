Dealer = class("Dealer")

function Dealer:initialize()
    self.state = "dealing"
    self.step = 0
    self.timer = 0
    
    self.drawDeckX = 1280
    self.drawDeckY = 15
    
    self.hands = {
        Hand:new(1920 / 2, 900)
    }
    self.dealerHand = DealerHand:new()

    self.currentHand = 1

    self.dealSpeed = 0.2


end

function Dealer:update(dt)
    if self.state == "dealing" then 
        self:deal(dt)
    elseif self.state == "player" then 
        self:playerState()
    elseif self.state == "dealerDraw" then 
        self:dealerDraw(dt)
    end

    self.dealerHand:update(dt)
    for i,v in pairs(self.hands) do
        v:update(dt)
    end
end

function Dealer:draw()
    self.dealerHand:draw()
    for i,v in pairs(self.hands) do
        v:draw()
    end
end

function Dealer:mousepressed(x, y, button)
    self.dealerHand:mousepressed(x, y, button)
    for i,v in pairs(self.hands) do
        v:mousepressed(x, y, button)
    end
end

function Dealer:deal(dt)
    self.timer = self.timer + dt

    if self.timer < self.dealSpeed then 
        return
    end
    self.timer = 0
    self.step = self.step + 1


    if self.step == 1 or self.step == 3 then 
        local card = player:drawCard()
        self.dealerHand:addCard(card)
    elseif self.step == 2 or self.step == 4 then 
        local card = player:drawCard()
        self.hands[1]:addCard(card)
    elseif self.step == 5 then 
        self.state = "player"
    end
end

function Dealer:playerState()
    self.hands[self.currentHand].showSum = true
end

function Dealer:dealerDraw(dt)
    self.timer = self.timer + dt
    if self.timer < self.dealSpeed then 
        return
    end
    self.timer = 0
    self.step = self.step + 1

    local card = player:drawCard()
    self.dealerHand:addCard(card)

    local sum = self.dealerHand:getSum()

    if sum >= 16 and sum <= 21 then 
        self.state = "evaluate"
    elseif sum > 21 then 
        self.state = "bust"
    end

    
end

function Dealer:hit()
    if self.state ~= "player" then return end
    
    local card = player:drawCard()
    self.hands[self.currentHand]:addCard(card)

end

function Dealer:stand()
     if self.state ~= "player" then return end

     self.currentHand = self.currentHand + 1

     if self.currentHand > #self.hands then 
        self.state = "dealerDraw"
     end

end

function Dealer:split()
    if self.state ~= "player" then return end

    local currentHand = self.hands[self.currentHand]
    local newHand = Hand:new(currentHand.x, currentHand.y)
    newHand:addCard(currentHand.cards[2])
    currentHand:removeCard(2)

    table.insert(self.hands, newHand)

    
    for i,v in pairs(self.hands) do
        v:setTarget(spaceEvenly(#self.hands, #self.hands - (i-1), 1920/2, 200), v.targetY)
    end


end

