SMODS.Joker({
	key = "tetris",
	loc_txt = {
		name = "Tetris",
		text = {
			"This Joker Gains {X:mult,C:white}X#1#{} Mult",
			"per {C:attention}consecutive{} hand",
			"played without",
			"repeating a {C:attention}poker hand{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			Xmult = 1,
			Xmult_mod = 0.5,
			played_hands = {},
		},
	},
	atlas = "jokers",
	pos = { y = 0, x = 5 },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,

	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and not context.blueprint then
			if card.ability.extra.played_hands[context.scoring_name] then
				card.ability.extra.played_hands = {}
				card.ability.extra.Xmult = 1
				return {
					card = card,
					message = localize("k_reset"),
				}
			else
				card.ability.extra.played_hands[context.scoring_name] = true
				card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
			end
		end
		if context.joker_main then
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
