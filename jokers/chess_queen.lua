-- Chess queen
-- destroy cards and gain Xmult
SMODS.Joker({
    key = "chess_queen",
    loc_txt = {
        name = "Queen",
        text = {
            "When blind is selected,",
            "destroy all cards",
            "of {C:attention}lowest{} rank",
            "in your full deck.",
            "This Joker gains {X:mult,C:white}X#2#{} Mult",
            "for each card destroyed",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
        },
    },
    config = {
        extra = {
            Xmult = 1,
            Xmult_mod = 0.1,
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
            vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod },
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

            -- keep track of xmult
            local mult_mod = 0
            for i, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == min then
                    mult_mod = mult_mod + card.ability.extra.Xmult_mod
                    -- Destroy card
                    playing_card:start_dissolve(nil, i ~= 1)
                end
            end
            -- Add xmult to card and display it
            card.ability.extra.Xmult = card.ability.extra.Xmult + mult_mod
            card_eval_status_text(card, "extra", nil, nil, nil, {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { card.ability.extra.Xmult },
                }),
            })
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize({
                    type = "variable",
                    key = "a_xmult",
                    vars = { card.ability.extra.Xmult },
                }),
                Xmult_mod = card.ability.extra.Xmult,
            }
        end
    end,
})
