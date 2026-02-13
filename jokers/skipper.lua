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
            local scaling = {
                scalar_value,
                operation,
            }
            if G.GAME.blind.boss then
                scaling.scalar_value = "xmult_gain"
                scaling.operation = "+"
            else
                scaling.scalar_value = "xmult_loss"
                scaling.operation = function(ref_table, ref_value, initial, change)
                    local new_value = initial - change
                    if new_value < 1 then
                        new_value = 1
                    end
                    ref_table[ref_value] = new_value
                end
            end

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = scaling.scalar_value,
                operation = scaling.operation,
                message_key = "a_xmult",
                message_colour = G.C.MULT
            })
        end
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
})
