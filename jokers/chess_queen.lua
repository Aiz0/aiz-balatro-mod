-- Chess queen
-- destroy cards and gain Xmult
SMODS.Joker({
	key = "chess_queen",
	loc_txt = {
		name = "Queen",
		text = {
			"When round begins,",
			"destroy all cards",
			"of {C:attention}lowest{} rank",
			"in your full deck.",
			"This Joker gains {X:mult,C:white}X{} Mult",
			"for each card destroyed",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			Xmult = 1,
			Xmult_mod = 0.05,
		},
	},
	atlas = "jokers",
	pos = { y = 13, x = 0 },
	rarity = 3,
	cost = 15,
	blueprint_compat = false,
	-- makes sure this joker doesn't spawn in any pools
	yes_pool_flag = "this flag will never be set",

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,

	calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint then
			-- Find out what smallest id in deck is
			local min = math.huge
			for _, playing_card in ipairs(G.playing_cards) do
				min = min < playing_card:get_id() and min or playing_card:get_id()
			end
			-- stone cards don't have set id
			-- but it's always less than 1
			if min < 1 then
				min = 1
			end
			for i, playing_card in ipairs(G.playing_cards) do
				if playing_card:get_id() <= min then
					-- Add to Xmult
					local mult_mod = card.ability.extra.Xmult_mod * min
					card.ability.extra.Xmult = card.ability.extra.Xmult + mult_mod
					-- Destroy card
					playing_card:start_dissolve(nil, i ~= 1)
				end
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
