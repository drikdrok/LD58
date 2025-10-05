Shop = class("Shop")

function Shop:initialize()
    
    self.width  = 700
    self.height = 800
    
    self.x = love.graphics.getWidth() - self.width
    self.y = 0

    self.cards = {}

    self:restock()

    self.enabled = true


    self.restockButton = Button:new(-350, -450, 275, 75, "Restock: $100", function()
        if player.balance - player.minBet >= self.restockFee then 
            self:restock()
            player:addBalance(-self.restockFee)
            self.restockFee = self.restockFee * 2
            self.restockButton.text = "Restock $"..self.restockFee
        end
    end):setAnchor(1,1)
    self.restockButton.enabled = true
    
    self.restockFee = 100
end

function Shop:update(dt)
    if not self.enabled then return end 
    for i,v in pairs(self.cards) do
        v:update(dt)
    end


end

function Shop:draw()
    if not self.enabled then return end 
    love.graphics.push()
        love.graphics.translate(self.x, self.y)

        game:setFont(32)
        love.graphics.setColor(1,1,1)
        love.graphics.print("Shop", self.width / 2 - game.font:getWidth("Shop"), 10)

        for i,v in pairs(self.cards) do
            v:draw()
        end


    love.graphics.pop()

    self.restockButton:draw()
end

function Shop:restock()
    self.cards = {}

    local freshDeck = defaultDeck()
    -- Playing cards
    for x = 1, 3 do 
        local index = love.math.random(1, #freshDeck)
        local card = freshDeck[index]
        local newItem = ShopCard:new(card):setPosition(100 + 160 * (x-1), 100)

        local n = love.math.random()
        if n > 0.65 then
            newItem:addRandomEnchantment()
        end

        table.insert(self.cards, newItem)
        table.remove(freshDeck, index)
    end


    --Spell Cards
    for x = 1, 3 do 
        local index = love.math.random(1, #freshDeck)

        local n = love.math.random()
        local spellClass
        if n < 0.65 then
            spellClass = BurnSpellCard
        else
            spellClass = DuplicateSpellCard
        end
        local newItem = spellClass:new():setPosition(100 + 160 * (x-1), 350)


        table.insert(self.cards, newItem)
        table.remove(freshDeck, index)
    end

end

function Shop:mousepressed(x, y, button)
    if not self.enabled then return end 
    for i,v in pairs(self.cards) do
        v:mousepressed(x, y, button)
    end
    self.restockButton:mousepressed(x, y, button)
end

function Shop:mousereleased(x, y, button)
    self.restockButton:mousereleased(x, y, button)
end

function Shop:hide()
    self.enabled = false
    self.restockButton.enabled = false
end

function Shop:show()
    self.enabled = true
    self.restockButton.enabled = true
end









ShopCard = class("ShopCard")

function ShopCard:initialize(card)
    self.x = 0
    self.y = 0

    self.width = cardWidth
    self.height = cardHeight

    self.scale = 1.2
    self.targetScale = 1.2
    self.defaultScale = 1.2

    self.card = card

    self.price = 100

    
end

function ShopCard:update(dt)
    if self.purchased then return end 
    self.scale = lerp(self.scale, self.targetScale, 6 * dt)

    if self:isMouseOver() then 
        self.targetScale = 1.3
        tooltip:setContent(self:getTooltip()):setPosition(shop.x + self.x - 15, shop.x + self.x + self.width + 15, self.y)
    else
        self.targetScale = 1.2
    end
    
end

function ShopCard:setPosition(x, y)
    self.x = x
    self.y = y
    return self
end

function ShopCard:draw()
    if self.purchased then return end 
    love.graphics.setColor(1, 1, 1)

    love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.translate(self.width / 2, self.height / 2)
        love.graphics.scale(self.scale, self.scale)
        love.graphics.translate(-self.width / 2, -self.height / 2)
        self:renderCard()
    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
    local text = "$"..self.price
    game:setFont(20)
    if not self:playerCanAfford() then 
        love.graphics.setColor(1,0,0)
    end
    love.graphics.print(text, self.x + self.width / 2 - game.font:getWidth(text) / 2, self.y + self.height + 30)

    if debug then 
        love.graphics.setColor(0,0,1)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end

function ShopCard:mousepressed(x, y, button)
    if self.purchased then return end 
    if button == 1 and self:isMouseOver() and self:playerCanAfford() then 
        self:onPurchase()
    end
end

function ShopCard:isMouseOver() 
  local mouseX, mouseY = love.mouse.getPosition()

    local x = shop.x + self.x
    local y = shop.y + self.y

    return pointInRect({mouseX, mouseY}, {x, y, self.width, self.height})  
end

function ShopCard:renderCard()
    self.card:render()
end


function ShopCard:playerCanAfford()
    return player.balance - player.minBet >= self.price
end


function ShopCard:onPostSpell ()
    
end
function ShopCard:onPurchase ()
    player:addCard(self.card)
    self.purchased = true
    player:addBalance(-self.price)
end

function ShopCard:addRandomEnchantment()
    local enchantments = {
        MultiplierEnchantment,
        WinPushEnchantment,
        FreebieEnchantment,
    }

    local enchantmentClass = enchantments[love.math.random(1, #enchantments)]

    self.card:addEnchantment(enchantmentClass:new())

end

function ShopCard:getTooltip()
    if self.card then 
        return self.card:getTooltip()
    end
    if self.tooltip then 
        return {self.tooltip}
    end
    return {}
end




local sprite = love.graphics.newImage("assets/gfx/cards/blank.png")

--Burn Spell
BurnSpellCard = class("BurnSpellCard", ShopCard)
function BurnSpellCard:initialize()
    ShopCard.initialize(self)
    self.deckViewerText = "Select a Card to DESTROY!"
    self.tooltip = TooltipContent:new("Burn Spell", {"DESTROY a Card From Your Collection"})
end

function BurnSpellCard:onPurchase()
    deckViewer:setSpellCard(self)
end

function BurnSpellCard:onPostSpell(card)
    player:removeCard(card)
    deckViewer:setSpellCard(nil)
    deckViewer:hide()
    player:addBalance(-self.price)
    self.purchased = true
end

function BurnSpellCard:renderCard()
    love.graphics.setColor(1, 0, 0)
    love.graphics.draw(sprite, 0, 0, 0, 1.5, 1.5)
end



--Duplicate Spell
DuplicateSpellCard = class("DuplicateSpellCard", ShopCard)
function DuplicateSpellCard:initialize()
    ShopCard.initialize(self)
    self.deckViewerText = "Select a Card to Copy!"
     self.tooltip = TooltipContent:new("DNA Spell", {"Duplicate a Card In Your Collection"})
end

function DuplicateSpellCard:onPurchase()
    deckViewer:setSpellCard(self)
end

function DuplicateSpellCard:onPostSpell(card)
    player:copyCard(card)
    deckViewer:setSpellCard(nil)
    deckViewer:hide()
    player:addBalance(-self.price)
    self.purchased = true
end

function DuplicateSpellCard:renderCard()
    love.graphics.setColor(0, 0, 1)
    love.graphics.draw(sprite, 0, 0, 0, 1.5, 1.5)
end
