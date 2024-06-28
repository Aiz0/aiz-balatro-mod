SMODS.Joker({
	key = "skipper",
	loc_txt = {
		name = "Skipper",
		text = {
			"Gain {X:mult,C:white}X#1#{} when",
			"{C:attention}Boss Blind{} is defeated",
			"Lose {X:mult,C:white}X#2#{} when",
			"{C:attention}Small Blind{} or {C:attention}Big Blind{}",
			"is defeated",
			"{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			Xmult_mod_positive = 1,
			Xmult_mod_negative = 0.5,
			Xmult = 1,
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 3 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.Xmult_mod_positive,
				card.ability.extra.Xmult_mod_negative,
				card.ability.extra.Xmult,
			},
		}
	end,

	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			if G.GAME.blind.boss then
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod_positive
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize({
						type = "variable",
						key = "a_xmult",
						vars = { card.ability.extra.Xmult },
					}),
				})
			elseif card.ability.extra.Xmult > 1 then
				card.ability.extra.Xmult = card.ability.extra.Xmult - card.ability.extra.Xmult_mod_negative
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize({
						type = "variable",
						key = "a_xmult",
						vars = { card.ability.extra.Xmult },
					}),
				})
			end
		end
		if context.joker_main and card.ability.extra.Xmult > 1 then
			return {
				message = localize({
					type = "variable",
					key = "a_xmult",
					vars = { card.ability.extra.Xmult },
				}),
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end,
})
