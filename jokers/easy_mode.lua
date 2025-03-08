SMODS.Joker({
    key = "easy_mode",
    config = {
        extra = {
            mult_mod = 0.5,
            sticker = "white",
        },
    },
    atlas = "jokers",
    pos = { y = 0, x = 2 },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,

    get_mult = function(card)
        local mult = 0
        -- Add mult for every sticker matching
        for _, v in pairs(G.P_CENTERS) do
            if v.set == "Joker" then
                if
                    get_joker_win_sticker(v, false)
                    == card.ability.extra.sticker
                then
                    mult = mult + card.ability.extra.mult_mod
                end
            end
        end
        return math.floor(mult)
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 1 / card.ability.extra.mult_mod, self.get_mult(card) },
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = self.get_mult(card),
            }
        end
    end,
})
