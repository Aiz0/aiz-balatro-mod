-- Chess rook
-- Turn cards into stone.
-- Discarded cards are turned
-- -1 discard because of this.
SMODS.Joker({
	key = "chess_rook",
	loc_txt = {
		name = "Rook",
		text = {
			"Discarded cards are",
			"turned to stone",
			"{C:attention}-#1#{} discards",
		},
	},
	config = {
		extra = {
			discard_size = 1,
		},
	},
	atlas = "jokers",
	pos = { y = 14, x = 0 },
	rarity = 3,
	cost = 8,
	blueprint_compat = false,
	-- makes sure this joker doesn't spawn in any pools
	yes_pool_flag = "this flag will never be set",

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discard_size } }
	end,

	calculate = function(self, card, context)
		if context.pre_discard and not context.blueprint then
			for i = 1, #G.hand.highlighted do
				Aiz.utils.flip_card_event(G.hand.highlighted[i])
			end
			for i = 1, #G.hand.highlighted do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.1,
					func = function()
						G.hand.highlighted[i]:set_ability(G.P_CENTERS["m_stone"])
						return true
					end,
				}))
			end
			for i = 1, #G.hand.highlighted do
				Aiz.utils.flip_card_event(G.hand.highlighted[i])
			end
		end
	end,

	add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_size
		ease_discard(-card.ability.extra.discard_size)
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_size
		ease_discard(card.ability.extra.discard_size)
	end,
})
