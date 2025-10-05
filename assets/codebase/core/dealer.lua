Dealer = class("Dealer")

local backside = love.graphics.newImage("assets/gfx/cards/backside.png")

function Dealer:initialize()
    self.state = "betting"
    self.step = 0
    self.timer = 0
    
    self.drawDeckX = 200
    self.drawDeckY = 150
    
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
    elseif self.state == "payout" then 
        self:payout(dt)
    end

    self.dealerHand:update(dt)
    for i,v in pairs(self.hands) do
        v:update(dt)
    end
end

function Dealer:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(backside, self.drawDeckX - cardWidth / 2, self.drawDeckY - cardHeight / 2, 0, 1.5, 1.5)
    
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

function Dealer:startRound()
    self.state = "dealing"
    self.step = 0
    self.timer = 0
    self.hands = {
        Hand:new(1920 / 2, 900)
    }
    self.dealerHand = DealerHand:new()

    player:reshuffle()

    self.hands[1].betAmount = player.currentBet
    player:addBalance(-player.currentBet)
    self.currentHand = 1
end


-- Dealer states
function Dealer:deal(dt)
    self.timer = self.timer + dt

    if self.timer < self.dealSpeed then 
        return
    end
    self.timer = 0
    self.step = self.step + 1

    if self.step == 1 then 
        local card = player:drawCard()
        self.dealerHand:addCard(card)
    elseif self.step == 2 or self.step == 4 then 
        local card = player:drawCard()
        self.hands[1]:addCard(card)
    elseif self.step == 3 then 
        local card = player:drawCard(true)
        self.dealerHand:addCard(card)
       -- if self.dealerHand:isBlackjack() then 
       ---     self:startPayout()
       -- end 
    elseif self.step == 5 then 
        self.state = "player"
    end
end

function Dealer:playerState()
    local currentHand = self.hands[self.currentHand]

    currentHand.showSum = true

    game.hud.splitButton.enabled = false
    if #currentHand.cards == 2 and currentHand.cards[1]:getValue() == currentHand.cards[2]:getValue() and player.balance >= player.currentBet then 
        game.hud.splitButton.enabled = true
    end

    game.hud.hitButton.enabled = true
    game.hud.standButton.enabled = true

    --First hand is blackjack!
    if #self.hands == 1 and self.hands[self.currentHand]:isBlackjack() then 
        self:startDealerDraw()
    end
end

function Dealer:dealerDraw(dt)

    local sum = self.dealerHand:getSum()

    if sum > 16 then 
        self:startPayout()
    end

    self.timer = self.timer + dt
    if self.timer < self.dealSpeed then 
        return
    end
    self.timer = 0
    self.step = self.step + 1

    local card = player:drawCard()
    self.dealerHand:addCard(card)
end

function Dealer:payout(dt)
    self.timer = self.timer + dt
    if self.timer < self.dealSpeed then 
        return
    end
    self.timer = 0
    self.step = self.step + 1

    local dealerSum = self.dealerHand:getSum()
    local dealerBust = dealerSum > 21
    local dealerBlackjack = self.dealerHand:isBlackjack()

    local currentHand = self.hands[self.currentHand]
    local handSum = currentHand:getSum()
    local playerBlackjack = currentHand:isBlackjack()

    currentHand:onScore()
    if playerBlackjack then 
        currentHand:onBlackjack()
    end

    if handSum <= 21 then
        if playerBlackjack then 
            currentHand.winMultiplier = currentHand.winMultiplier * 1.5
        end

        if dealerBust or handSum > dealerSum then 
            currentHand:winHand()
           self.statusText = "Win!"
            if playerBlackjack then 
                self.statusText = "Blackjack!"
            end

            dealer.dealerHand.statusText = "Not enough!"
            if dealerBust then 
                dealer.dealerHand.statusText = "Bust!"
            end
        elseif handSum == dealerSum then 
            player:addBalance(currentHand.betAmount)
            currentHand.statusText = "Push."
            self.dealerHand.statusText = "Push."

            currentHand:onPush()
        else
            currentHand.statusText = "Not enough!"
            self.dealerHand.statusText = "Win!"
            if dealerBlackjack then 
                self.dealerHand.statusText = "Blackjack!"
            end
        end
    else
        currentHand.statusText = "Bust!"
    end


    self.currentHand = self.currentHand + 1

    if self.currentHand > #self.hands then 
        self.state = "done"
        game.hud.continueButton.enabled = true
    end
end


function Dealer:endRound()
    self.state = "betting"
    player:reshuffle()
    shop:restock()
    shop:show()
    for i,v in pairs(self.hands) do 
        v:collect()
    end
    self.dealerHand:collect()
    game.hud:setMakeBets(true)
end

function Dealer:startDealerDraw()
    self.state = "dealerDraw"
    self.dealerHand:setFlipped(false)
    game.hud.splitButton.enabled = false
end




-- Player actions
function Dealer:hit()
    if self.state ~= "player" then return end
    
    local card = player:drawCard()
    self.hands[self.currentHand]:addCard(card)

    local handSum = self.hands[self.currentHand]:getSum()
    if handSum >= 21 then 
        if handSum > 21 then 
            self.hands[self.currentHand].statusText = "Bust!"
        end
        if self.hands[self.currentHand]:isBlackjack() then 
            self.hands[self.currentHand].statusText = "Blackjack!"
        end
        self.currentHand = self.currentHand + 1
        if self.currentHand > #self.hands then 
            self:startDealerDraw()
        end 
    end
end

function Dealer:stand()
     if self.state ~= "player" then return end

     self.currentHand = self.currentHand + 1

     if self.currentHand > #self.hands then 
        self:startDealerDraw()
    end

end

function Dealer:split()
    if self.state ~= "player" then return end

    local currentHand = self.hands[self.currentHand]
    local newHand = Hand:new(currentHand.x, currentHand.y)
   
    newHand:addCard(currentHand.cards[2])
    currentHand:removeCard(2)

    newHand.betAmount = currentHand.betAmount
    player:addBalance(-currentHand.betAmount)

    table.insert(self.hands, newHand)

    
    for i,v in pairs(self.hands) do
        v:setTarget(spaceEvenly(#self.hands, #self.hands - (i-1), 1920/2, 200), v.targetY)
    end
end

function Dealer:startPayout()
    self.state = "payout"
    self.currentHand = 1
    self.dealerHand.cards[2].flipped = false
    game.hud.hitButton.enabled = false
    game.hud.standButton.enabled = false
end