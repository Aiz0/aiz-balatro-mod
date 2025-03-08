SMODS.Joker({
    key = "loudspeaker",
    config = {},
    atlas = "jokers",
    pos = { y = 0, x = 1 },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,

    get_chips = function()
        return math.floor(
            (
                G.SETTINGS.SOUND.music_volume
                + G.SETTINGS.SOUND.game_sounds_volume
            )
                * G.SETTINGS.SOUND.volume
                / 200
        )
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { self.get_chips() } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = self.get_chips(),
            }
        end
    end,
})
