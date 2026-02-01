SMODS.Joker({
    key = "blåhaj",
    config = {
        card_limit = 1,
    },
    atlas = "jokers_soul",
    pos = { y = 0, x = 0 },
    soul_pos = { y = 0, x = 1 },
    rarity = 1,
    cost = 1,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.card_limit } }
    end,
})
