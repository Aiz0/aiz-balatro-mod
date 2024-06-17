SMODS.Joker({
	key = "gamer",
	loc_txt = {
		name = "Ultimate Gamer",
		text = {
			"{C:chips}+#1#{} Chips for each",
			"{C:attention}Challenge{} you have",
			"{C:attention}Completed{}",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
		},
	},
	config = {
		extra = {
			chips_mod = 10,
			chips = 1,
		},
	},
	--TODO add sprite
	--atlas = "jokers",
	pos = { y = 0, x = 0 },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
	end,

	set_ability = function(self, card)
		card.ability.extra.chips = G.PROGRESS and G.PROGRESS.challenges.tally * card.ability.extra.chips_mod
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_chips",
					vars = { card.ability.extra.chips },
				}),
				chip_mod = card.ability.extra.chips,
			}
		end
	end,
})
