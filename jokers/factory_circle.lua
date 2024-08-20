SMODS.Joker({
    key = "factory_circle",
    loc_txt = {
        name = "Circle",
        text = {
            "{C:chips}+#1#{} Chips",
        },
    },
    config = {
        extra = {
            chips = 10,
        },
    },
    atlas = "jokers",
    pos = { y = 4, x = 0 },
    rarity = 1,
    cost = 2,
    blueprint_compat = true,
    -- makes sure this joker doesn't spawn in any pools
    yes_pool_flag = "this flag will never be set",
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize({
                    type = "variable",
                    key = "a_chips",
                    vars = { card.ability.extra.chips },
                }),
                chip_mod = card.ability.extra.chips,
            }
        end
    end,
})
