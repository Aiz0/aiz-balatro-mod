-- it says schmeven but its actually any card with rank lower than 0

local play_wario = false
SMODS.Sound({
    key = "musicwario",
    path = "wario.ogg",
    select_music_track = function(self)
        if play_wario then
            return 7
        end
    end,
})

SMODS.Joker({
    key = "schmeven",
    config = {
        extra = {
            Xmult = 1.5,
        },
    },
    atlas = "jokers",
    pos = { y = 3, x = 3 },
    rarity = 2,
    cost = 2,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() < 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.8, 0.8)
                        play_wario = true
                        return true
                    end,
                }))
                delay(2)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.8, 0.8)
                        play_wario = false
                        return true
                    end,
                }))
            end
        end
    end,
})
