SMODS.Joker({
    key = "randomizer",
    config = {
        extra = { repetitions = 4, scored_cards = 0 },
    },
    atlas = "jokers",
    pos = { y = 2, x = 1 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.scored_cards = 0
        end
        if context.repetition and context.cardarea == G.play then
            card.ability.extra.scored_cards = card.ability.extra.scored_cards
                + 1
            if card.ability.extra.scored_cards == 5 then
                card.ability.extra.scored_cards = 0
                return {
                    repetitions = card.ability.extra.repetitions,
                }
            end
        end
    end,
})
