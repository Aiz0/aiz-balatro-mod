-- AntiBubzia
-- Sets chips and mult to 0
-- if negative, squares chips and mult

SMODS.Joker({
    key = "antibubzia",
    atlas = "jokers",
    pos = { y = 0, x = 3 },
    rarity = 3,
    cost = 10,
    blueprint_compat = false,

    set_ability = function(self, card)
        card.ability.eternal = true
    end,

    calculate = function(self, card, context)
        if context.final_scoring_step then
            local text = localize("k_aiz_cancelled")
            local xmult = 0
            local xchips = 0
            if card.edition and card.edition.negative then
                xmult = mult
                xchips = hand_chips
                text = localize("k_aiz_squared")
            end
            return {
                xmult = xmult,
                xchips = xchips,
                remove_default_message = true, --instead do a gong with text
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "before",
                        delay = 4.3,
                        func = function()
                            play_sound("gong", 0.94, 0.3)
                            play_sound("gong", 0.94 * 1.5, 0.2)
                            play_sound("tarot1", 1.5)
                            attention_text({
                                scale = 1.4,
                                text = text,
                                hold = 2,
                                align = "cm",
                                offset = { x = 0, y = -2.7 },
                                major = G.play,
                            })
                            return true
                        end,
                    }))
                end,
            }
        end
    end,
})
