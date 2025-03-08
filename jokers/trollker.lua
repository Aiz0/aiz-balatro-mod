SMODS.Joker({
    key = "trollker",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 1,
            cards_per_mult = 3,
            blocking = { cards = {}, positions = {} },
        },
    },
    atlas = "jokers",
    pos = { y = 1, x = 1 },
    rarity = 3,
    cost = 10,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod },
        }
    end,

    calculate = function(self, card, context)
        -- clean up blocking cards
        -- increment xmult
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            for i, blocking_card in ipairs(card.ability.extra.blocking.cards) do
                blocking_card:start_dissolve(
                    nil,
                    i ~= #card.ability.extra.blocking.cards
                )
            end
            -- needs to be reset manually
            card.ability.extra.blocking.positions = {}

            card.ability.extra.xmult = card.ability.extra.xmult
                + card.ability.extra.xmult_mod
            return { message = localize("k_upgrade_ex") }
        end

        -- Give xmult when scored
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end

        -- Spawn blocking cards on first hand drawn and before scoring a hand
        if
            not context.blueprint
            and (
                context.first_hand_drawn
                or (context.before and context.cardarea == G.jokers)
            )
        then
            -- spawn cards for each mult it gives minus 1
            -- so that it only starts spawning cards when it gives xmult
            for i = 1, math.floor(
                (card.ability.extra.xmult - 1)
                    * card.ability.extra.cards_per_mult
            ), 1 do
                -- IDK if these values work everywhere but i guess its good enough for now
                --TODO move to a config or something
                local position = {
                    x = pseudorandom("trollker", 0, 18),
                    y = pseudorandom("trollker", 0, 9),
                }
                Aiz.utils.create_blocking_card(card, position, i ~= 1)
            end
            if card.ability.extra.xmult > 1 then
                return { message = localize("k_aiz_trolled") }
            end
        end
    end,

    -- on load create blocking cards again
    load = function(self, card, card_table, other_card)
        Aiz.utils.load_blocking_cards(card, card_table)
    end,
})
