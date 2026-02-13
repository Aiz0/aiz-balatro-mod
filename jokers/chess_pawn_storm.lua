SMODS.Joker({
    key = "chess_pawn_storm",
    config = {
        extra = {
            pawns = 2,
            pawn_key = "j_aiz_chess_pawn",
        },
    },
    atlas = "jokers",
    pos = { y = 3, x = 2 },
    rarity = 2,
    cost = 9,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pawns } }
    end,

    calculate = function(self, card, context)
        -- Basically Riff-Raff for pawns
        if
            context.setting_blind
            and not card.getting_sliced
            and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
            and not next(SMODS.find_card(card.ability.extra.pawn_key))
        then
            local jokers_to_create = math.min(
                card.ability.extra.pawns,
                G.jokers.config.card_limit
                    - (#G.jokers.cards + G.GAME.joker_buffer)
            )
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _ = 1, jokers_to_create do
                        SMODS.add_card({
                            key = card.ability.extra.pawn_key,
                        })
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end,
            }))
            return {
                message = localize("k_plus_joker"),
                colour = G.C.BLUE,
            }
        end
    end,
})
