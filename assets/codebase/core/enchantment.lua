Enchantment = class("Enchantment")

function Enchantment:initialize()
    self.color = {0.8, 0.4, 0.9} 
end

function Enchantment:onScore(hand)

end

function Enchantment:onBlackjack(hand)

end


MultiplierEnchantment = class("MultiplierEnchantment", Enchantment)
function MultiplierEnchantment:initialize()
    Enchantment.initialize(self)
end

function MultiplierEnchantment:onScore(hand)
    hand.winMultiplier = hand.winMultiplier + 0.25
end


WinPushEnchantment = class("WinPushEnchantment", Enchantment)
function WinPushEnchantment:initialize()
    Enchantment.initialize(self)
    self.color = {0.3, 0.4, 0.9} 
end
