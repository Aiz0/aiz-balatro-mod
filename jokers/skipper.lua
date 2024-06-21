SMODS.Joker({
	key = "skipper",
	loc_txt = {
		name = "Skipper",
		text = {
			"Upgrade the level of",
			"your {C:attention}most played{}",
			"poker hand",
			"when skipping a {C:attention}Blind",
		},
	},
	config = {
		extra = {
			levels = 1,
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 3 },
	rarity = 1,
	cost = 2,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.skip_blind then
			local _hand, _tally = nil, 0
			for k, v in ipairs(G.handlist) do
				if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
					_hand = v
					_tally = G.GAME.hands[v].played
				end
			end
			if _hand then
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
					handname = _hand,
					chips = G.GAME.hands[_hand].chips,
					mult = G.GAME.hands[_hand].mult,
					level = G.GAME.hands[_hand].level,
				})
				level_up_hand(card, _hand, nil, card.ability.extra.levels)
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
			end
		end
	end,
})
