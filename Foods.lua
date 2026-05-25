--- STEAMODDED HEADER
--- MOD_NAME: Foods
--- MOD_ID: foods
--- MOD_AUTHOR: Munkhbayar
--- MOD_DESCRIPTION: Ketchup makes everything better! Doubles the chips and mult of all Food Jokers.

-- 1. Register the Sprite Atlas (Your Pixel Art)
SMODS.Atlas({
    key = 'foods_atlas',
    path = 'ketcup.png',
    px = 71,
    py = 95
})

-- 2. Define our Food Jokers target list
local food_jokers = {
    j_ramen = true,
    j_cavendish = true,
    j_popcorn = true,
    j_ice_cream = true,
    j_egg = true,
    j_turtle_bean = true,
    j_diet_cola = true,
    j_gros_michel = true
}

-- 3. Define the Voucher
SMODS.Voucher({
    key = 'ketcup_voucher',
    loc_txt = {
        name = 'KETCup',
        text = {
            "All Food Jokers give",
            "{X:mult,C:white} X2 {} Mult and",
            "double their {C:chips}Chips{}"
        }
    },
    cost = 10,
    atlas = 'foods_atlas',
    pos = { x = 0, y = 0 },
    
    -- When you buy KETCup, instantly double the stats of Food Jokers you already own!
    redeem = function(self, card)
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                local joker = G.jokers.cards[i]
                -- Check if it is a food joker and has an "extra" stats table
                if food_jokers[joker.config.center.key] and joker.ability.extra then
                    if joker.ability.extra.mult then joker.ability.extra.mult = joker.ability.extra.mult * 2 end
                    if joker.ability.extra.Xmult then joker.ability.extra.Xmult = joker.ability.extra.Xmult * 2 end
                    if joker.ability.extra.chips then joker.ability.extra.chips = joker.ability.extra.chips * 2 end
                end
            end
        end
    end
})

-- 4. Apply the buff to new Food Jokers bought AFTER you own the voucher
local original_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    -- Run the original game code first so it builds the Joker normally
    original_set_ability(self, center, initial, delay_sprites)
    
    -- Then check if the player owns KETCup and if the new card is a Food Joker
    if G.GAME and G.GAME.used_vouchers.v_foods_ketcup_voucher and food_jokers[self.config.center.key] and self.ability.extra then
        if self.ability.extra.mult then self.ability.extra.mult = self.ability.extra.mult * 2 end
        if self.ability.extra.Xmult then self.ability.extra.Xmult = self.ability.extra.Xmult * 2 end
        if self.ability.extra.chips then self.ability.extra.chips = self.ability.extra.chips * 2 end
    end
end

