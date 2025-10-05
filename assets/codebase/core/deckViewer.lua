DeckViewer = class("DeckViewer")

function DeckViewer:initialize()

    self.width = 700
    self.height = 400

    self.x = love.graphics.getWidth()
    self.y = love.graphics.getHeight() - self.height

    self.targetX = self.x

    self.active = false

    self.deck = {}
    self.suits = {}

    self.spellCard = nil

    self.hideCooldown = 0
     
end

function DeckViewer:update(dt)
    if math.abs(self.targetX - self.x) > 2 then 
        self.x = lerp(self.x, self.targetX, 10*dt)
    else
        self.x = self.targetX
    end

    for suit = 1, #self.suits do 
        for i=#self.suits[suit], 1, -1 do -- Reverse order
            if self.suits[suit][i]:mouseOver() then 
                break
            end
        end
    end

    for i,v in pairs(self.deck) do
        v:update(dt)
    end

    self.hideCooldown = self.hideCooldown + dt

end

function DeckViewer:draw()
    love.graphics.push()
        love.graphics.translate(self.x, self.y)

        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)

        love.graphics.setColor(0,0,0)
        local text = "My Collection"
        if self.spellCard and self.spellCard.deckViewerText then 
            text = self.spellCard.deckViewerText 
        end
        
        game:setFont(18)
        love.graphics.print(text, self.width/2 - game.font:getWidth(text)/2, 10)


        for i,v in pairs(self.deck) do
            v:draw()            
        end

    love.graphics.pop()
end


function DeckViewer:show()
    self.targetX = love.graphics.getWidth() - self.width
    self.active = true
    game.hud.deckViewerButton.text = "<"

    self:loadDeck()
end

function DeckViewer:hide()
    self.targetX = love.graphics.getWidth()
    self.active = false
    game.hud.deckViewerButton.text = ">"
end

function DeckViewer:loadDeck()
    self.deck = {}

    -- Used to order the viewCards
    self.suits = {
        {}, {}, {}, {}
    }

    for i,v in pairs(player.deck) do
        local card = ViewCard:new(v, false) 
        table.insert(self.suits[v.suit], card)
        table.insert(self.deck, card)
    end
    for i,v in pairs(player.usedDeck) do
        local card = ViewCard:new(v, not v.flipped)
        table.insert(self.suits[v.suit], card)
        table.insert(self.deck, card)
    end

    for suit = 1, #self.suits do 
        table.sort(self.suits[suit], function(a, b)
            return a.card.rank > b.card.rank
        end)
        for i, v in pairs(self.suits[suit]) do
            
            local spacing = (self.width - 100) / (#self.suits[suit]) 
            v.x = (i-1) * spacing + 30
            
            v.y = (suit-1) * 80 + 50
            v.defaultY = (suit-1) * 80 + 50
            v.targetY = (suit-1) * 80 + 50
        end

        table.sort(self.suits[suit], function(a, b)
            return a.x < b.x
        end)
    end

    table.sort(self.deck, function(a, b)
        if a.y == b.y then 
            if a.card.rank == b.card.rank then 
                return a.x < b. x
            end
            return a.card.rank > b.card.rank
        end
        return a.y < b.y
    end)

end

function DeckViewer:mousepressed(x, y, button)
    if self.burnCard and self.hideCooldown > 2 then 
        if x < self.x or y < self.y then
            self:hideBurnCard()
        end
    end

    for suit = 1, #self.suits do 
        for i=#self.suits[suit], 1, -1 do -- Reverse order
            self.suits[suit][i]:mousepressed(x, y, button)
        end
    end
end

function DeckViewer:mousereleased(x,y, button)

end


function DeckViewer:setSpellCard(card)
    if card then 
        self.spellCard = card
        self.hideCooldown = 0
        self:show()
    else
        self.spellCard = nil
        self:hide()
    end
end


ViewCard = class("ViewCard")

function ViewCard:initialize(card, used)
    self.card = card
    self.isUsed = used

    self.x = 0
    self.y = 0

    self.targetY = self.y
    self.defaultY = self.y

    self.highlight = false
    self.scale = 0.5
end

function ViewCard:update(dt)
    if math.abs(self.y - self.targetY) < 1 then 
        self.y = self.targetY
    else
        self.y = lerp(self.y, self.targetY, 10*dt)
    end
    self.targetY = self.defaultY
end

function ViewCard:draw()
     if not self.card then return end 
    love.graphics.setColor(1,1,1)
    if self.isUsed then 
        love.graphics.setColor(0.65, 0.65, 0.65)
    end
    love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.scale(self.scale, self.scale)
        self.card:render()
    love.graphics.pop()

    if debug then 
        local x =  self.x
        local y = self.defaultY
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("line",x, y, self.card.width * self.scale, self.card.height * self.scale)
    end
end

function ViewCard:mouseOver()
    if not self.card then return end 
    local mouseX, mouseY = love.mouse.getPosition()

    local x = deckViewer.x + self.x
    local y = deckViewer.y + self.defaultY

    if pointInRect({mouseX, mouseY}, {x, y, self.card.width * self.scale, self.card.height * self.scale}) then 
        self.targetY = self.defaultY - 30
        return true
    end    
end

function ViewCard:mousepressed(x, y, button)
    if not button == 1 or not self:mouseOver() then return end
    
    
    if deckViewer.spellCard ~= nil then 
        deckViewer.spellCard:onPostSpell(self.card)
    end
end