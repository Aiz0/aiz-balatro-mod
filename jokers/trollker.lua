SMODS.Joker({
	key = "trollker",
	loc_txt = {
		name = "Trollker",
		text = {
			"This Joker gains {X:mult,C:white}X#2#",
			"Mult at end of round.",
			"This joker may do",
			"a little bit of {C:attention,E:1,S:1.1}Trolling",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			Xmult = 1,
			Xmult_mod = 1,
			cards_per_mult = 3,
			cards = {},
			card_positions = {},
		},
	},
	atlas = "jokers",
	pos = { y = 16, x = 0 },
	rarity = 3,
	cost = 10,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod } }
	end,

	calculate = function(self, card, context)
		-- increment xmult at end of round
		-- clean up cards
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			card_eval_status_text(card, "extra", nil, nil, nil, {
				message = localize("k_upgrade_ex"),
			})
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
			-- TODO move this logic to blocking cards themselves
			for i, blocking_card in ipairs(card.ability.extra.cards) do
				blocking_card:start_dissolve(nil, i ~= #card.ability.extra.cards)
			end
			-- needs to be reset manually
			card.ability.extra.card_positions = {}
		end
		-- Give Xmult when scored
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

		-- Spawn blocking cards on first hand drawn and before scoring a hand
		if
			not context.blueprint and (context.first_hand_drawn or (context.cardarea == G.jokers and context.before))
		then
			if card.ability.extra.Xmult > 1 then
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_aiz_trolled") })
			end
			-- spawn cards for each mult it gives
			-- -1 so that it only starts spawning cards when it gives xmult
			for i = 1, math.floor((card.ability.extra.Xmult - 1) * card.ability.extra.cards_per_mult), 1 do
				-- IDK if these values work everywhere but i guess its good enough for now
				--TODO move to a config or something
				local position = {
					x = pseudorandom("trollker", 0, 18),
					y = pseudorandom("trollker", 0, 9),
				}
				Create_blocking_card(card, position, i ~= 1)
			end
		end
	end,
	load = function(self, card, card_table, other_card)
		card.ability = card_table.ability
		-- These cards don't exist anymore
		card.ability.extra.cards = {}
		-- Create new ones with same positions
		for i, position in ipairs(card.ability.extra.card_positions) do
			Create_blocking_card(card, position, i ~= 1)
		end
	end,
})
