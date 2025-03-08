SMODS.Joker({
    key = "chill_joker",
    config = {
        extra = {
            Xmult = 2,
        },
    },
    atlas = "jokers",
    pos = { y = 0, x = 0 },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,

    get_mult = function(card)
        return round_number(card.ability.extra.Xmult / G.SETTINGS.GAMESPEED, 1)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, self.get_mult(card) } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = self.get_mult(card),
            }
        end
    end,
})
