SMODS.Joker({
    key = "kiki_bouba",
    loc_txt = {
        name = "Kiki/Bouba",
        text = {
            "{C:attention}Kiki{} Jokers",
            "each give {C:mult}+#1#{} Mult",
            "{C:attention}Bouba{} Jokers",
            "each give {C:chips}+#2#{} Chips",
        },
    },
    config = {
        extra = {
            mult = 6,
            chips = 30,
        },
    },
    atlas = "jokers",
    pos = { y = 2, x = 5 },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if
            context.other_joker
            and context.other_joker ~= card
        then
            local is_kiki =
                Aiz.config.is_kiki[context.other_joker.config.center_key]
            if is_kiki == nil then return
            return {
                mult = is_kiki and card.ability.extra.mult or 0,
                chips = not is_kiki and card.ability.extra.chips or 0,
            }
        end
    end,
})
