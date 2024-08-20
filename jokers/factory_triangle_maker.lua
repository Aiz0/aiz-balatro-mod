SMODS.Joker({
    key = "factory_triangle_maker",
    loc_txt = {
        name = "Triangle factory",
        text = {
            "When Blind is selected,",
            "create a",
            "{C:dark_edition}negative{} {C:attention}Triangle",
        },
    },
    config = {},
    atlas = "jokers",
    pos = { y = 3, x = 4 },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue + 1] = {
            set = "Joker",
            key = "j_aiz_factory_triangle",
            specific_vars = {
                G.P_CENTERS["j_aiz_factory_triangle"].config.extra.mult,
            },
        }
        return {
            vars = {},
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local key = "j_aiz_factory_triangle"
            if pseudorandom("triangle_factory") <= 0.2 then
                key = "j_aiz_factory_circle"
            end
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.3,
                blockable = false,
                func = function()
                    local new_card = SMODS.create_card({
                        key = key,
                        no_edition = true,
                    })
                    new_card:set_edition("e_negative")
                    new_card:add_to_deck()
                    new_card.ability.extra_value = -3 --to make sell thingy zero by default
                    new_card:set_cost()
                    G.jokers:emplace(new_card)
                    return true
                end,
            }))
        end
    end,
})
