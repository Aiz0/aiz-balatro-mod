SMODS.Joker({
	key = "ultimate_gamer",
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
			cost_mod = 1 / 3,
		},
	},
	--TODO add sprite
	atlas = "jokers_soul",
	pos = { y = 1, x = 0 },
	soul_pos = { y = 1, x = 1 },
	rarity = 2,
	cost = 1,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
	end,

	set_ability = function(self, card)
		local multiplier = G.PROGRESS and G.PROGRESS.challenges.tally
		card.ability.extra.chips = card.ability.extra.chips_mod * multiplier
		-- cost is based on how powerful it is
		card.base_cost = card.base_cost + card.ability.extra.cost_mod * multiplier
		card:set_cost()
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
