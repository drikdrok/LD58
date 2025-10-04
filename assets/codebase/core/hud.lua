Hud = class("Hud")

function Hud:initialize()
    self.buttons = {
        Button:new(100, -300, 125, 75, "Hit", function()
            dealer:hit()
        end):setAnchor(0.5, 1),
    
        Button:new(100, -200, 125, 75, "Stand", function()
            dealer:stand()
        end):setAnchor(0.5, 1),

        Button:new(100, -100, 125, 75, "Split", function()
            dealer:split()
        end):setAnchor(0.5, 1)
    }

    self.splitButton = self.buttons[3]

end

function Hud:update(dt)

end

function Hud:draw()
    for i, v in pairs(self.buttons) do
        v:draw()        
    end
end

function Hud:mousepressed(x, y, button)
    for i,v in pairs(self.buttons) do
        v:mousepressed(x, y, button)
    end
end

function Hud:mousereleased(x, y, button)
    for i,v in pairs(self.buttons) do
        v:mousereleased(x, y, button)
    end
end