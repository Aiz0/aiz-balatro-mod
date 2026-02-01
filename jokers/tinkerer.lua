SMODS.Joker({
    key = "tinkerer",
    config = {
        extra = {
            xmult_mod = 0.1,
            xmult = 1,
        },
    },
    atlas = "jokers",
    pos = { y = 2, x = 2 },
    rarity = 2,
    cost = 9,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult },
        }
    end,

    set_ability = function(self, card)
        local xmult = card.ability.extra.xmult
        for _, modInfo in ipairs(SMODS.mod_list) do
            if modInfo.can_load and not modInfo.disabled then
                xmult = xmult + card.ability.extra.xmult_mod
            end
        end
        card.ability.extra.xmult = xmult
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end
    end,
})
