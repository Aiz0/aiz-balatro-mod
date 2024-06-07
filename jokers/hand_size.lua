SMODS.Joker({
	key = "hand_size",
	loc_txt = {
		name = "Too Much To Handle",
		text = {
			"At end of round",
			"set a random hand size",
			"between {C:attention}#1#{} and {C:attention}#2#{}",
			"{C:inactive}(Currently {C:attention}#3##4#{C:inactive} hand size)",
		},
	},
	config = {
		extra = {
			hand_size = {
				max = 15,
				min = 4,
				current = 8,
				difference = 0,
			},
		},
	},
	atlas = "jokers",
	pos = { y = 6, x = 0 },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		local sign = ""
		if card.ability.extra.hand_size.difference >= 0 then
			sign = "+"
		end
		return {
			vars = {
				card.ability.extra.hand_size.min,
				card.ability.extra.hand_size.max,
				sign,
				card.ability.extra.hand_size.difference,
			},
		}
	end,

	set_random_hand_size = function(card)
		card.ability.extra.hand_size.current = pseudorandom(
			pseudoseed("aiz_hand_size"),
			card.ability.extra.hand_size.min,
			card.ability.extra.hand_size.max
		)
		card.ability.extra.hand_size.difference = card.ability.extra.hand_size.current
			- (G.hand and G.hand.config.card_limit or 8)
	end,

	set_ability = function(self, card)
		self.set_random_hand_size(card)
	end,

	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			G.hand:change_size(-card.ability.extra.hand_size.difference)
			G.E_MANAGER:add_event(Event({
				func = function()
					self.set_random_hand_size(card)
					G.hand:change_size(card.ability.extra.hand_size.difference)
					return true
				end,
			}))
		end
	end,

	add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_size.difference)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_size.difference)
	end,
})