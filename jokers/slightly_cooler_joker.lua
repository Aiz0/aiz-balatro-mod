SMODS.Joker({
    key = "slightly_cooler_joker",
    config = { extra = { mult = 5 } },
    atlas = "jokers",
    pos = { y = 3, x = 0 },
    rarity = 1,
    cost = 2,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end,
})
