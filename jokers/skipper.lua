SMODS.Joker({
    key = "skipper",
    config = {
        extra = {
            xmult_gain = 1,
            xmult_loss = 0.75,
            xmult = 1,
        },
    },
    atlas = "jokers",
    pos = { y = 2, x = 3 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_gain,
                card.ability.extra.xmult_loss,
                card.ability.extra.xmult,
            },
        }
    end,

    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            if G.GAME.blind.boss then
                card.ability.extra.xmult = card.ability.extra.xmult
                    + card.ability.extra.xmult_gain
            else
                card.ability.extra.xmult = card.ability.extra.xmult
                    - card.ability.extra.xmult_loss
                if card.ability.extra.xmult < 1 then
                    card.ability.extra.xmult = 1
                end
            end
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { card.ability.extra.xmult },
                }),
                colour = G.C.MULT,
            }
        end
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
})
