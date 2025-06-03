SMODS.Joker({
    key = "ultimate_unknown",
    config = {
        extra = {
            amount = 3,
            levels = 1,
        },
    },
    atlas = "jokers_soul",
    pos = { y = 1, x = 2 },
    soul_pos = { y = 1, x = 3 },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount } }
    end,

    calculate = function(self, card, context)
        if context.skip_blind then
            local hands = {}
            for _, hand in ipairs(G.handlist) do
                if G.GAME.hands[hand].visible then
                    table.insert(hands, hand)
                end
            end
            -- shuffle array before sorting it by played hands
            -- this randomizes which 3 hands are picked each time
            Aiz.utils.pseudorandom_shuffle(hands, self.key)
            table.sort(hands, function(a, b)
                return G.GAME.hands[a].played < G.GAME.hands[b].played
            end)

            for i, hand in ipairs(hands) do
                if i > card.ability.extra.amount then
                    break
                end
                SMODS.smart_level_up_hand(
                    card,
                    hand,
                    false,
                    card.ability.extra.levels
                )
            end
        end
    end,
})
