Player = class("Player")

love.graphics.setDefaultFilter("nearest", "nearest")

function Player:initialize()
    self.deck = defaultDeck()

    self.usedDeck = {}



    self.currentBet = 100
    self.balance = 1000

    self.minBet = 100

    self.displayBalance = self.balance

end

function Player:update(dt)
    self.displayBalance = lerp(self.displayBalance, self.balance, dt)
    if math.abs(self.displayBalance - self.balance) <= 5 then 
        self.displayBalance = self.balance
    end
end

function Player:draw()

end


function Player:drawCard(flipped)
    
    local card

    if #self.deck > 0 then 
        local index = love.math.random(1, #self.deck)
        card = self.deck[index]
        table.remove(self.deck, index)
    else
        card = defaultDeck()[math.random(1, 52)]
        card:addEnchantment(EphemeralEnchantment:new())
    end
    
    table.insert(self.usedDeck, card)

    card:setPosition(dealer.drawDeckX, dealer.drawDeckY)

    if flipped then 
        card.flipped = true
    end

    deckViewer:loadDeck()

    return card
end

function Player:reshuffle()
    for i,v in pairs(self.usedDeck) do
        if not v:hasEnchantment(EphemeralEnchantment) then
            table.insert(self.deck, v)   
            v.flipped = false -- IDK
        end
    end
    self.usedDeck = {}
end

function Player:addBalance(amount)
    self.balance = self.balance + amount
end

function Player:changeBet(amount)
    self.currentBet = self.currentBet + amount
    if self.currentBet < self.minBet then 
        self.currentBet = self.minBet
    elseif self.currentBet > self.balance then 
        self.currentBet = self.balance
    end
end


function Player:addCard(card)
    table.insert(self.deck, card)
end

function Player:removeCard(card)
    for i,v in pairs(self.deck) do
        if self.deck[i] == card then 
            table.remove(self.deck, i)
            break
        end
    end
end

function Player:copyCard(card)
    for i,v in pairs(self.deck) do
        if self.deck[i] == card then 
            -- TODO: copy enchantments
            local copy = Card:new(card.rank, card.suit)

            for i,v in pairs(card.enchantments) do
                copy:addEnchantment(v.class:new())
            end

            table.insert(self.deck, copy)
        end
    end
end
