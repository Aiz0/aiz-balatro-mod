SMODS.Joker({
    key = "battle_pass",
    loc_txt = {
        name = "Battle Pass",
        text = {
            "{C:attention}+#1#{} levels when a",
            "poker hand is upgraded",
            "Does not apply to",
            "{C:attention}Planet cards",
        },
    },
    config = {
        extra = {
            levels = 2,
        },
    },
    atlas = "jokers",
    pos = { y = 3, x = 1 },
    rarity = 1,
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.levels } }
    end,
})
