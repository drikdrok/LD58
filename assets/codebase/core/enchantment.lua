Enchantment = class("Enchantment")

function Enchantment:initialize()
    self.color = {0.8, 0.4, 0.9} 

    self.tooltip = TooltipContent:new("Enchantment", {"More, longer text that blah", "blah blah blah blah"})
end

function Enchantment:onScore(hand)

end

function Enchantment:onBlackjack(hand)

end

function Enchantment:onDraw()

end

-- MultiplierEnchantment
MultiplierEnchantment = class("MultiplierEnchantment", Enchantment)
function MultiplierEnchantment:initialize()
    Enchantment.initialize(self)
    self.tooltip = TooltipContent:new("Multiplier", {"+0.25 hand mult when scored"})
end

function MultiplierEnchantment:onScore(hand)
    hand.winMultiplier = hand.winMultiplier + 0.25
end

-- WinPushEnchantment
WinPushEnchantment = class("WinPushEnchantment", Enchantment)
function WinPushEnchantment:initialize()
    Enchantment.initialize(self)
    self.color = {0.3, 0.4, 0.9} 
    self.tooltip = TooltipContent:new("Gun Finga", {"Win hand on push"})
end

-- FreebieEnchantment
FreebieEnchantment = class("FreebieEnchantment", Enchantment)
function FreebieEnchantment:initialize()
    Enchantment.initialize(self)
    self.color = {0.5, 0.9, 0.5} 
    self.tooltip = TooltipContent:new("Freebie", {"Draw another hand for free!"})
end

function FreebieEnchantment:onDraw()
    if dealer.currentHand > #dealer.hands then return end
    local currentHand = dealer.hands[dealer.currentHand]
    local newHand = Hand:new(currentHand.x, currentHand.y)
    newHand:addCard(player:drawCard())
    newHand:addCard(player:drawCard())
    newHand.betAmount = player.currentBet
    dealer:addHand(newHand)
end


-- Ephemeral
EphemeralEnchantment = class("FreebieEnchantment", Enchantment)
function EphemeralEnchantment:initialize()
    Enchantment.initialize(self)
    self.color = {0.6, 0.6, 0.6} 
    self.tooltip = TooltipContent:new("Ephemeral", {"Gets destroyed at end of round"})
end