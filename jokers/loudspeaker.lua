SMODS.Joker({
	key = "loudspeaker",
	loc_txt = {
		name = "Loudspeaker",
		text = {
			"Gives {C:chips}Chips{} based",
			"on {C:attention}Audio volume{}",
			"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
		},
	},
	config = {},
	atlas = "jokers",
	pos = { y = 10, x = 0 },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,

	get_chips = function()
		return math.floor(
			(G.SETTINGS.SOUND.music_volume + G.SETTINGS.SOUND.game_sounds_volume) * G.SETTINGS.SOUND.volume / 200
		)
	end,

	loc_vars = function(self, info_queue, card)
		return { vars = { self.get_chips() } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { self.get_chips() },
				}),
				chip_mod = self.get_chips(),
			}
		end
	end,
})
