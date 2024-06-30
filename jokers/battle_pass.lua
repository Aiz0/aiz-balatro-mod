SMODS.Joker({
	key = "battle_pass",
	loc_txt = {
		name = "Battle Pass",
		text = {
			"{C:attention}+#1#{} levels when a",
			"poker hand is upgraded",
			"Does not apply to",
			"{C:attention}Planet cards",
		},
	},
	config = {
		extra = {
			levels = 2,
		},
	},
	atlas = "jokers",
	pos = { y = 3, x = 1 },
	rarity = 2,
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.levels } }
	end,
})
