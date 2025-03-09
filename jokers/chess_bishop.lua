SMODS.Joker({
    key = "chess_bishop",
    config = {
        extra = {
            money_number = 1,
            money_face = -1,
        },
    },
    atlas = "jokers",
    pos = { y = 1, x = 4 },
    rarity = 2,
    cost = 6,
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
            vars = {
                card.ability.extra.money_number,
                card.ability.extra.money_face * -1,
            },
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_face() then
                return { dollars = card.ability.extra.money_face }
            elseif
                context.other_card:get_id() >= 2.
                and context.other_card:get_id() <= 10
            then
                return { dollars = card.ability.extra.money_number }
            end
        end
    end,
})
