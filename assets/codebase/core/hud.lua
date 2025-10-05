Hud = class("Hud")

function Hud:initialize()
    self.buttons = {
        Button:new(100, -150, 125, 60, "Hit", function()
            dealer:hit()
        end):setAnchor(0.5, 0.5),
    
        Button:new(-100, -150, 125, 60, "Stand", function()
            dealer:stand()
        end):setAnchor(0.5, 0.5),

        Button:new(0, -75, 125, 60, "Split", function()
            dealer:split()
        end):setAnchor(0.5, 0.5),


        Button:new(0, 100, 400, 150, "Play", function()
            dealer:startRound()
            self:setMakeBets(false)
            deckViewer:setSpellCard(nil)
            shop:hide()
        end):setAnchor(0.5, 0.5):setTextSize(40),

        Button:new(-50, -200, 50, 50, "<", function()
            if deckViewer.active then 
                deckViewer:hide()
                self.deckViewerButton.text = "<"
            else
                deckViewer:show()
                self.deckViewerButton.text = ">"
            end
        end):setAnchor(1,1),

        Button:new(0, -250, 400, 150, "Continue", function()
            dealer:endRound()
            self.continueButton.enabled = false
        end):setAnchor(0.5, 0.5):setTextSize(40),
    }

    self.hitButton = self.buttons[1]
    self.standButton = self.buttons[2]
    self.splitButton = self.buttons[3]
    self.startRoundButton = self.buttons[4]
    self.deckViewerButton = self.buttons[5]
    self.continueButton = self.buttons[6]

    self.deckViewerButton.enabled = true


    self.makeBets = true

    local centerX = love.graphics.getWidth() / 2
    local centerY = love.graphics.getHeight() / 2 - 200
    self.betAdjusters = {
        BetAdjuster:new(50, centerX, centerY),
        BetAdjuster:new(25, centerX + 85, centerY),
        BetAdjuster:new(10, centerX + 170, centerY)
    }


    self.floatingTexts = {}
end

function Hud:update(dt)
    for i,v in pairs(self.floatingTexts) do
        v:update(dt)
    end

    deckViewer:update(dt)
    self.deckViewerButton.x = deckViewer.x - 50
end

function Hud:draw()
    game:setFont(24)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Balance: $"..math.floor(player.displayBalance))

    for i,v in pairs(self.floatingTexts) do
        v:draw()
    end
    
    
    for i, v in pairs(self.buttons) do
        v:draw()        
    end


    if self.makeBets then 
        for i,v in pairs(self.betAdjusters) do
            v:draw()
        end
        game:setFont(36)
        local text = "Make Bet: $"..player.currentBet

        local x = love.graphics.getWidth() / 2 - game.font:getWidth(text) - 50
        love.graphics.print(text, x, love.graphics.getHeight() / 2 - 200)
         
        game:setFont(20)
        love.graphics.print("Min. Bet: $"..player.minBet, x, love.graphics.getHeight() / 2 - 150)
    end


    deckViewer:draw()
end

function Hud:addButton(button)
    self.buttons[button] = button
end

function Hud:removeButton(button)
    if self.buttons[button] then 
        self.buttons[button] = nil
    end
end

function Hud:mousepressed(x, y, button)
    for i,v in pairs(self.buttons) do
        v:mousepressed(x, y, button)
    end

    for i,v in pairs(self.betAdjusters) do
        v:mousepressed(x, y, button)
    end
end

function Hud:mousereleased(x, y, button)
    for i,v in pairs(self.buttons) do
        v:mousereleased(x, y, button)
    end

    for i,v in pairs(self.betAdjusters) do
        v:mousereleased(x, y, button)
    end
end


function Hud:setMakeBets(value)
    self.makeBets = value

    self.floatingTexts = {}
    
    for i,v in pairs(self.betAdjusters) do
        v:setActive(value)
    end
    self.startRoundButton.enabled = value
end 