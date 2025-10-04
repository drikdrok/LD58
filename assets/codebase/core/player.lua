Player = class("Player")

function Player:initialize()
    self.deck = defaultDeck()

    self.usedCards = {}
end

function Player:update(dt)

end

function Player:draw()

end


function Player:drawCard()
    if #self.deck == 0 then 
        error("Deck is empty!")
    end
    local index = love.math.random(1, #self.deck)
    local card = self.deck[index]
    table.remove(self.deck, index)

    card:setPosition(dealer.drawDeckX, dealer.drawDeckY)


    return card
end


