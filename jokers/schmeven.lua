-- it says schmeven but its actually any card with rank lower than 0
SMODS.Joker({
    key = "schmeven",
    loc_txt = {
        name = "Schmeven",
        text = {
            "Played cards with",
            "{C:attention}schmeven{} rank give",
            "{X:mult,C:white}X#1#{} Mult when scored",
        },
    },
    config = {
        extra = {
            Xmult = 1.5,
        },
    },
    atlas = "jokers",
    pos = { y = 3, x = 3 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() < 0 then
                return {
                    x_mult = card.ability.extra.Xmult,
                    card = card,
                }
            end
        end
    end,
})
