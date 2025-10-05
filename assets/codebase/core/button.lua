Button = class("Button")

function Button:initialize(x, y, width, height, text, onClick)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.text = text

    self.onClick = onClick

    self.textSize = 24

    self.color = {0.5, 0.5, 0.5}

    self.enabled = false

    self.isDown = false
end


function Button:update(dt)

end


function Button:draw()
    if not self.enabled then return end

    local alpha = 0.7
    if self.isDown then 
        alpha = 0.5
    end

    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alpha)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1,1,1,1)
    game:setFont(self.textSize)
    love.graphics.print(self.text, self.x + self.width / 2 - game.font:getWidth(self.text) / 2, self.y + self.height / 2 - game.font:getHeight(self.text) / 2)
end

function Button:mousepressed(x, y, button)
    if not self.enabled or game.hasClicked then return end
    if pointInRect({x,y}, {self.x, self.y, self.width, self.height}) then
        self.isDown = true
        game.hasClicked = true
        self.onClick()
    end
end

function Button:mousereleased(x, y, button)
     if not self.enabled then return end
    if pointInRect({x,y}, {self.x, self.y, self.width, self.height}) then
    end

    self.isDown = false
end

-- Set anchor relative to screen width, height
function Button:setAnchor(x, y)
    local width, height = love.graphics.getDimensions()
    self.x = self.x + width    * x - self.width / 2
    self.y = self.y + height   * y - self.height / 2

    return self
end

function Button:setTextSize(size)
    self.textSize = size
    return self
end