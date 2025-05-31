SMODS.Joker({
    key = "randomizer",
    config = {
        extra = { chips = 20 },
    },
    atlas = "jokers",
    pos = { y = 2, x = 1 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return { chips = card.ability.extra.chips }
        end
    end,
})
