-- Chess pawn
-- After a few rounds it promotes to a different chess joker
SMODS.Joker({
    key = "chess_pawn",
    config = {
        extra = {
            rank = 2,
            promotion_rank = 8,
            move = 1,
            first_move = 2,
        },
    },
    atlas = "jokers",
    pos = { y = 1, x = 2 },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rank } }
    end,

    calculate = function(self, card, context)
        -- Just give mult
        if context.joker_main then
            return {
                mult = card.ability.extra.rank,
            }
        end

        -- should increment rank and show appropate message after round or skip
        if
            (
                context.end_of_round
                and not context.individual
                and not context.repetition
                and not context.blueprint
            ) or context.skip_blind
        then
            local move = (card.ability.extra.rank == 2) and "first_move" or "move"
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rank",
                scalar_value = move,
                scaling_message = {
                    message = localize("k_aiz_advance")
                }
            })

            if card.ability.extra.rank >= card.ability.extra.promotion_rank then
                return {
                    message = localize("k_aiz_promoted"),
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound("tarot1")
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({
                                    trigger = "after",
                                    delay = 0.3,
                                    blockable = false,
                                    func = function()
                                        SMODS.add_card({
                                            set = "aiz_chess_promotion_joker",
                                            edition = card.edition,
                                            stickers = card.stickers,
                                        })
                                        card:remove()
                                        return true
                                    end,
                                }))
                                return true
                            end,
                        }))
                    end,
                }
            end
        end
    end,
})
