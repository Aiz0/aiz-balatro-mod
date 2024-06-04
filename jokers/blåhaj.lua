SMODS.Joker({
	key = "blåhaj",
	loc_txt = {
		name = "Blåhaj",
		text = {
			"{C:dark_edition}+#1#{} Joker slots",
		},
	},
	config = {
		extra = {
			joker_slots = 1,
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 0 },
	soul_pos = { y = 2, x = 1 },
	rarity = 1,
	cost = 1,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.joker_slots } }
	end,

	add_to_deck = function(card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
	end,
	remove_from_deck = function(card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.joker_slots
	end,
})
