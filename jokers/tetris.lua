SMODS.Joker({
    key = "tetris",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.5,
            played_hands = {},
        },
    },
    atlas = "jokers",
    pos = { y = 0, x = 5 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult },
        }
    end,

    calculate = function(self, card, context)
        if
            context.before
            and context.cardarea == G.jokers
            and not context.blueprint
        then
            if card.ability.extra.played_hands[context.scoring_name] then
                card.ability.extra.played_hands = {}
                card.ability.extra.xmult = 1
                return {
                    message = localize("k_reset"),
                }
            else
                card.ability.extra.played_hands[context.scoring_name] = true
                card.ability.extra.xmult = card.ability.extra.xmult
                    + card.ability.extra.xmult_mod
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
})
