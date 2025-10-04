function pointInRect(point, rect)
    local px = point[1]
    local py = point[2]

    local rx = rect[1]
    local ry = rect[2]
    local rw = rect[3]
    local rh = rect[4]

    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

function lerp(a,b,t) return (1-t)*a + t*b end




function defaultDeck()
   return {
    -- Hearts (1)
    Card:new(1, 1),  -- Ace of Hearts
    Card:new(2, 1),
    Card:new(3, 1),
    Card:new(4, 1),
    Card:new(5, 1),
    Card:new(6, 1),
    Card:new(7, 1),
    Card:new(8, 1),
    Card:new(9, 1),
    Card:new(10, 1),
    Card:new(11, 1), -- Jack
    Card:new(12, 1), -- Queen
    Card:new(13, 1), -- King

    -- Diamonds (2)
    Card:new(1, 2),
    Card:new(2, 2),
    Card:new(3, 2),
    Card:new(4, 2),
    Card:new(5, 2),
    Card:new(6, 2),
    Card:new(7, 2),
    Card:new(8, 2),
    Card:new(9, 2),
    Card:new(10, 2),
    Card:new(11, 2),
    Card:new(12, 2),
    Card:new(13, 2),

    -- Clubs (3)
    Card:new(1, 3),
    Card:new(2, 3),
    Card:new(3, 3),
    Card:new(4, 3),
    Card:new(5, 3),
    Card:new(6, 3),
    Card:new(7, 3),
    Card:new(8, 3),
    Card:new(9, 3),
    Card:new(10, 3),
    Card:new(11, 3),
    Card:new(12, 3),
    Card:new(13, 3),

    -- Spades (4)
    Card:new(1, 4),
    Card:new(2, 4),
    Card:new(3, 4),
    Card:new(4, 4),
    Card:new(5, 4),
    Card:new(6, 4),
    Card:new(7, 4),
    Card:new(8, 4),
    Card:new(9, 4),
    Card:new(10, 4),
    Card:new(11, 4),
    Card:new(12, 4),
    Card:new(13, 4),
}
end



-- Calculates the x position of an item spaced evenly around value k
-- x: total number of items
-- i: index of the item (1-based)
-- k: center position
-- spacing: distance between items
function spaceEvenly(x, i, k, spacing)
    if x % 2 == 1 then
        -- Odd number of items, centered at k
        local middle = math.ceil(x / 2)
        return k + (i - middle) * spacing
    else
        -- Even number of items, centered symmetrically around k
        local middleLeft = x / 2
        return k + ((i - middleLeft) - 0.5) * spacing
    end
end