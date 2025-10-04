require("assets/codebase/core/require")

love.graphics.setBackgroundColor(53 / 255, 101 / 255, 77 / 255)

function love.load()
    game = Game:new()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    if key == "escape" then 
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, isTouch, presses)
    game:mousepressed(x, y, button)
end 

function love.mousereleased(x, y, button, isTouch, presses)
    game:mousereleased(x, y, button)
end 