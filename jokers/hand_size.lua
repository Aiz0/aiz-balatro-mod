SMODS.Joker({
    key = "hand_size",
    config = {
        extra = {
            hand_size = {
                max = 15,
                min = 4,
                current = 8,
                difference = 0,
            },
        },
    },
    atlas = "jokers",
    pos = { y = 0, x = 4 },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        local sign = ""
        if card.ability.extra.hand_size.difference >= 0 then
            sign = "+"
        end
        return {
            vars = {
                card.ability.extra.hand_size.min,
                card.ability.extra.hand_size.max,
                sign,
                card.ability.extra.hand_size.difference,
            },
        }
    end,

    set_random_hand_size = function(card)
        card.ability.extra.hand_size.current = pseudorandom(
            pseudoseed("aiz_hand_size"),
            card.ability.extra.hand_size.min,
            card.ability.extra.hand_size.max
        )
        card.ability.extra.hand_size.difference = card.ability.extra.hand_size.current
            - (G.hand and G.hand.config.card_limit or 8)
    end,

    set_ability = function(self, card)
        self.set_random_hand_size(card)
    end,

    calculate = function(self, card, context)
        if
            context.setting_blind
            and not context.blueprint
            and not card.getting_sliced
        then
            G.hand:change_size(-card.ability.extra.hand_size.difference)
            G.E_MANAGER:add_event(Event({
                func = function()
                    self.set_random_hand_size(card)
                    G.hand:change_size(card.ability.extra.hand_size.difference)
                    return true
                end,
            }))

            return {
                message = localize("k_aiz_new_hand"),
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size.difference)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size.difference)
    end,
})
