SMODS.Joker({
	key = "slightly_cooler_joker",
	loc_txt = {
		name = "Slightly Cooler Joker",
		text = {
			"{C:mult}+#1#{} Mult",
		},
	},
	config = {
		extra = {
			mult = 5,
		},
	},
	atlas = "jokers",
	pos = { y = 3, x = 0 },
	rarity = 1,
	cost = 2,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.mult },
				}),
				mult_mod = card.ability.extra.mult,
			}
		end
	end,
})
