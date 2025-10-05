local suites = {
    love.graphics.newImage("assets/gfx/cards/heart.png"),
    love.graphics.newImage("assets/gfx/cards/diamond.png"),
    love.graphics.newImage("assets/gfx/cards/club.png"),
    love.graphics.newImage("assets/gfx/cards/spade.png"),
}

local cardText = {
    "A",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "J",
    "Q",
    "K"
}

local cardColor = {
    {197/255, 9/255, 59/255},
    {197/255, 9/255, 59/255},
    {0, 0, 0},
    {0, 0, 0},
}

local sprite = love.graphics.newImage("assets/gfx/cards/blank.png")

cardWidth = 75 * 1.5
cardHeight = 105 * 1.5

function drawCardPattern(rank, suit)
        
    love.graphics.draw(sprite, 0, 0, 0, 1.5, 1.5)
    love.graphics.setColor(cardColor[suit])

    game:setFont(20)
    if rank == 10 then 
        love.graphics.print("1", 2, 8)
        love.graphics.print("0", 9, 8)
    else
        love.graphics.print(cardText[rank], 8, 8)
    end
        

    love.graphics.setColor(1,1,1)
    local sprite = suites[suit]

    love.graphics.draw(sprite, 8, 35)

    local function drawRelative(x, y, flipped, scale)
        local spriteSize = 13
        local scale = scale or 2
        if flipped then
            love.graphics.draw(sprite, cardWidth * x + (spriteSize*scale) / 2, cardHeight * y - (spriteSize*scale) / 2, 0, -scale, -scale, 0, spriteSize*scale / 2)
        else
            love.graphics.draw(sprite, cardWidth * x - (spriteSize*scale) / 2, cardHeight * y - (spriteSize*scale) / 2, 0, scale)
        end
    end

    if rank == 1 then 
        drawRelative(0.5, 0.5, false, 3)
    elseif rank == 2 then 
        drawRelative(0.5, 0.15, false)
        drawRelative(0.5, 0.85, true)
    elseif rank == 3 then 
        drawRelative(0.5, 0.15, false)
        drawRelative(0.5, 0.5, false)
        drawRelative(0.5, 0.85, true)
    elseif rank == 4 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)
        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)
    elseif rank == 5 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)
        drawRelative(0.5, 0.5, false)
        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)
    elseif rank == 6 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)
        drawRelative(0.30, 0.5, false)
        drawRelative(0.70, 0.5, false)
        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)
    elseif rank == 7 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)
        drawRelative(0.5, 0.30, false)
        drawRelative(0.30, 0.5, false)
        drawRelative(0.70, 0.5, false)
        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)
    elseif rank == 8 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)

        drawRelative(0.30, 0.375, false)
        drawRelative(0.70, 0.375, false)

        drawRelative(0.30, 0.625, true)
        drawRelative(0.70, 0.625, true)

        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)

    elseif rank == 9 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)

        drawRelative(0.30, 0.375, false)
        drawRelative(0.70, 0.375, false)

        drawRelative(0.5, 0.5, false)

        drawRelative(0.30, 0.625, true)
        drawRelative(0.70, 0.625, true)

        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)

    elseif rank == 10 then 
        drawRelative(0.30, 0.15, false)
        drawRelative(0.70, 0.15, false)

        drawRelative(0.5, 0.3, false)

        drawRelative(0.30, 0.375, false)
        drawRelative(0.70, 0.375, false)


        drawRelative(0.30, 0.625, true)
        drawRelative(0.70, 0.625, true)

        drawRelative(0.5, 0.7, true)

        drawRelative(0.30, 0.85, true)
        drawRelative(0.70, 0.85, true)

    else
        game:setFont(48)
        love.graphics.setColor(cardColor[suit])
        love.graphics.print(cardText[rank], cardWidth / 2 - game.font:getWidth(cardText[rank]) / 2, cardHeight / 2 - game.font:getHeight(cardText[rank]) / 2)
    end



end
