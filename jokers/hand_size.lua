SMODS.Joker({
    key = "hand_size",
    loc_txt = {
        name = "Too Much To Handle",
        text = {
            "When blind is selected",
            "set a random hand size",
            "between {C:attention}#1#{} and {C:attention}#2#{}",
            "{C:inactive}(Currently {C:attention}#3##4#{C:inactive} hand size)",
        },
    },
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
    blueprint_compat = true,

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

            Aiz.utils.status_text(card, "k_aiz_new_hand")
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size.difference)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size.difference)
    end,
})
