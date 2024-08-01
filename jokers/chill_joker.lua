SMODS.Joker({
    key = "chill_joker",
    loc_txt = {
        name = "Chill Joker",
        text = {
            "{X:mult,C:white}X#1#{} Mult divided",
            "by game speed",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
        },
    },
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
        return card.ability.extra.Xmult / G.SETTINGS.GAMESPEED
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, self.get_mult(card) } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { self.get_mult(card) },
                }),
                Xmult_mod = self.get_mult(card),
            }
        end
    end,
})
