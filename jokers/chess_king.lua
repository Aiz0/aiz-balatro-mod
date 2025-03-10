SMODS.Joker({
    key = "chess_king",
    config = {
        extra = {
            xmult = 5,
        },
    },
    atlas = "jokers_soul",
    pos = { y = 0, x = 2 },
    soul_pos = { y = 0, x = 3 },
    rarity = 4,
    cost = 15,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    pools = {
        ["aiz_chess_promotion_joker"] = true,
    },

    calculate = function(self, card, context)
        if
            context.other_joker
            and context.other_joker.ability.set == "Joker"
            and context.other_joker ~= card
        then
            if string.find(context.other_joker.config.center_key, "chess") then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end,
                }))
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end,
})
