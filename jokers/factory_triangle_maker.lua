local factory_pool = SMODS.ObjectType({
    key = "aiz_factory",
    rarities = {
        { key = "Common", rate = 9 },
        { key = "Uncommon", rate = 1 },
    },
})

local factory_in_pool = function(self, args)
    return args and args.source == factory_pool.key, { allow_duplicates = true }
end

local factory_triangle = SMODS.Joker({
    key = "factory_triangle",
    config = { extra = { mult = 1 } },
    atlas = "jokers",
    pos = { y = 3, x = 5 },
    rarity = 1,
    cost = 1,
    pools = { [factory_pool.key] = true },
    in_pool = factory_in_pool,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end,
})

SMODS.Joker({
    key = "factory_circle",
    config = { extra = { chips = 10 } },
    atlas = "jokers",
    pos = { y = 4, x = 0 },
    rarity = 2,
    cost = 2,
    pools = { [factory_pool.key] = true },
    in_pool = factory_in_pool,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { set = "Other", key = self.key }
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
    end,
})

SMODS.Joker({
    key = "factory_triangle_maker",
    config = {},
    atlas = "jokers",
    pos = { y = 3, x = 4 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue + 1] = factory_triangle
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local new_card = SMODS.add_card({
                        set = factory_pool.key,
                        edition = "e_negative",
                        key_append = factory_pool.key,
                    })
                    new_card.base_cost = -99 --make cost 1 despite the edition
                    new_card.ability.extra_value = -1 --make sell value 1 despite the max 1
                    new_card:set_cost()
                    return true
                end,
            }))
            return {
                message = localize("k_plus_joker"),
                colour = G.C.BLUE,
            }
        end
    end,
})
