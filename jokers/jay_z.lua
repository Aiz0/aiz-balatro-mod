-- Jay-Z famous rapper
-- Sell for 500
-- Makes all cards polychrome
SMODS.Joker({
	key = "jay_z",
	loc_txt = {
		name = "Jay-Z",
		text = {
			"{C:green}#1# in #2#{} chance this",
			"card is destroyed and",
			"{C:dark_edition}Polychrome{} is added",
			"to {C:attention}All{} cards",
			"at end of round",
		},
	},
	config = {
		extra = {
			odds = 10,
		},
	},
	atlas = "jokers",
	pos = { y = 7, x = 0 },
	soul_pos = { y = 7, x = 1 },
	rarity = 4,
	-- sell price will be half this
	cost = 1000,
	blueprint_compat = false,

	loc_vars = function(self, info_queue, card)
		return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
	end,

	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			if pseudorandom(self.key) < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						-- Destroy Jay-Z
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				-- show message before polychrome starts
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_aiz_knowledge_gained") })
				-- Turn all cards polychrome
				-- start with cards held in hand
				for _, playing_card in ipairs(G.hand.cards) do
					Turn_polychrome(playing_card)
				end
				for _, joker_card in ipairs(G.jokers.cards) do
					Turn_polychrome(joker_card)
				end
				for _, consumable_card in ipairs(G.consumeables.cards) do
					Turn_polychrome(consumable_card)
				end
				-- Playing Cards in deck are done last and without a delay
				G.E_MANAGER:add_event(Event({
					func = function()
						for _, playing_card in ipairs(G.playing_cards) do
							playing_card:set_edition({ polychrome = true }, true, true)
						end
						return true
					end,
				}))
			else
				-- should halve the sell value if without edition
				card.base_cost = card.base_cost / 2
				card:set_cost()
				return {
					message = localize("k_aiz_dinner_postponed"),
				}
			end
		end
	end,
})