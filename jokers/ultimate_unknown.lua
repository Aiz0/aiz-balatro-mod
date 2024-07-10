SMODS.Joker({
	key = "ultimate_unknown",
	loc_txt = {
		name = "Ultimate ???",
		text = {
			"Upgrade the level of",
			"up to {C:attention}#1#{} of your",
			"{C:attention}least played{} poker hands",
			"when skipping a {C:attention}Blind",
		},
	},
	config = {
		extra = {
			amount = 3,
			levels = 1,
		},
	},
	atlas = "jokers_soul",
	pos = { y = 1, x = 2 },
	soul_pos = { y = 1, x = 3 },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount } }
	end,

	calculate = function(self, card, context)
		if context.skip_blind then
			local _hands, _tally = {}, math.huge
			for k, hand in ipairs(G.handlist) do
				if G.GAME.hands[hand].visible and G.GAME.hands[hand].played <= _tally then
					-- Reset table if new least played hand is found
					if G.GAME.hands[hand].played < _tally then
						_hands = {}
					end
					table.insert(_hands, hand)
					_tally = G.GAME.hands[hand].played
				end
			end
			while #_hands > card.ability.extra.amount do
				local _, key = pseudorandom_element(_hands, pseudoseed("remove_hand"))
				table.remove(_hands, key)
			end
			for k, hand in ipairs(_hands) do
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
					handname = hand,
					chips = G.GAME.hands[hand].chips,
					mult = G.GAME.hands[hand].mult,
					level = G.GAME.hands[hand].level,
				})
				level_up_hand(card, hand, nil, card.ability.extra.levels)
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
			end
		end
	end,
})
