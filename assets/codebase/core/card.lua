Card = class("Card")


local backside = love.graphics.newImage("assets/gfx/cards/backside.png")

local enchantmentShader = love.graphics.newShader("assets/codebase/shader/enchantedGlow.glsl")

function Card:initialize(rank, suit)
    self.x = 0
    self.y = 0

    self.targetX = 0
    self.targetY = 0
    self.lerpSpeed = 16

    self.width = 113
    self.height = 158

    self.rank = rank or 1
    self.suit = suit or 1

    self.flipped = false

    self.enchantments = {}

end

function Card:update(dt)
    self:drag(dt)
end

function Card:draw()
    love.graphics.setColor(1,1,1)

    if self.flipped then 
        love.graphics.draw(backside, self.x, self.y, 0, 1.5, 1.5)
    else
        love.graphics.push()
            love.graphics.translate(self.x, self.y)
            self:render()
        love.graphics.pop()
    end
end

function Card:render()
    
    love.graphics.setColor(1,1,1,1)
    if #self.enchantments > 0 and not self.flipped then 
        enchantmentShader:send("time", love.timer.getTime())
        enchantmentShader:send("tint_color", self.enchantments[1].color)
        enchantmentShader:send("base_strength", 0.7)           -- minimum tint strength
        enchantmentShader:send("pulse_amplitude", 0.5)         -- how much it pulses
        love.graphics.setShader(enchantmentShader)
    end

    drawCardPattern(self.rank, self.suit)

    love.graphics.setShader()
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

function Card:addEnchantment(enchantment)
    table.insert(self.enchantments, enchantment)
end

function Card:hasEnchantment(enchantmentClass)
    for i,v in pairs(self.enchantments) do
        if enchantmentClass == v.class then 
            return true 
        end
    end
    return false
end