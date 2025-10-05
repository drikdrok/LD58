Tooltip = class("Tooltip")

function Tooltip:initialize()
    self.content = {}
end

function Tooltip:update(dt)
    self.enabled = false
end

function Tooltip:setPosition(leftX, rightX, y)
    self.leftX = leftX
    self.y = y
    self.rightX = rightX
end

function Tooltip:draw()
    if not self.enabled then return end
    local width = 0
    local height = 50

    for i,v in pairs(self.content) do
        width = math.max(width, v:getWidth())        
        height = height + v:getHeight()
    end


    local x = self.rightX
    local y = math.max(0, self.y - height / 2)


    if self.rightX + width > love.graphics.getWidth() then -- Draw left 
        x = self.leftX - width
    else    
    --Draw Right
    end


    love.graphics.setColor(0.3, 0.3, 0.3, 0.9)
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor(1,1,1,1)
    local currentY = y
    for i,v in pairs(self.content) do
        love.graphics.push()
        love.graphics.translate(x, currentY)
        v:draw()
        love.graphics.pop()

        currentY = currentY + v:getHeight() + 10
    end

    game:setFont(20)
end

function Tooltip:setContent(content)
    self.content = content
    self.enabled = true
    return self
end


TooltipContent = class("TooltipContent") 

function TooltipContent:initialize(title, lines)
    self.title = title or "Tooltip"
    self.lines = lines or {"Blah blah blah", "This is a tooltip!"}
end

function TooltipContent:draw()
    game:setFont(20)
    love.graphics.print(self.title, 2, 2)
    for i,v in pairs(self.lines) do
        love.graphics.print(v, 2, i*23 + 10)
    end
end

function TooltipContent:getWidth()
    game:setFont(20)
    local width = game.font:getWidth(self.title) + 50
    for i,v in pairs(self.lines) do
        width = math.max(width, game.font:getWidth(v) + 50)
    end

    return width
end

function TooltipContent:getHeight()
    game:setFont(20)
    local height = game.font:getHeight(self.title)
    for i,v in pairs(self.lines) do
        height = height + game.font:getHeight(v)
    end

    return height
end