-- Chess queen
-- destroy cards and gain xmult
SMODS.Joker({
    key = "chess_queen",
    config = {
        extra = {
            xmult = 1,
            xmult_mod = 0.1,
        },
    },
    atlas = "jokers",
    pos = { y = 2, x = 0 },
    rarity = 3,
    cost = 15,
    blueprint_compat = true,
    pools = {
        ["aiz_chess_promotion_joker"] = true,
        ["Joker"] = false,
    },
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod },
        }
    end,

    calculate = function(self, card, context)
        if
            context.setting_blind
            and not context.blueprint
            and not card.getting_sliced
        then
            -- Find out what smallest id in deck is
            local min = math.huge
            for _, playing_card in ipairs(G.playing_cards) do
                -- ignore cards without ranks
                if playing_card:get_id() >= -100 then
                    min = min < playing_card:get_id() and min
                        or playing_card:get_id()
                end
            end

            -- keep track of cards destroyed
            local cards_destroyed = 0
            for i, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == min then
                    cards_destroyed = cards_destroyed + 1
                    -- Destroy card
                    playing_card:start_dissolve(nil, i ~= 1)
                end
            end
            -- Add xmult to card via scale function
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_mod",
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = initial + cards_destroyed * change
                end,
                message_key = "a_xmult",
                message_colour = G.C.MULT,
            })
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return { xmult = card.ability.extra.xmult }
        end
    end,
})
