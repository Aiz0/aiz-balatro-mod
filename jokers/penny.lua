SMODS.Joker({
	key = "penny",
	loc_txt = {
		name = "Penny",
		text = {
			"At end of round,",
			"duplicate {C:attention}All{} cards",
			"in your deck",
			"{s:0.5}Consider selling when game starts to lag!",
		},
	},
	atlas = "jokers",
	pos = { y = 12, x = 0 },
	rarity = 3,
	cost = 8,
	blueprint_compat = true,

	calculate = function(self, card, context)
		if context.end_of_round and not context.individual and not context.repetition then
			local new_cards = {}
			for _, playing_card in pairs(G.playing_cards) do
				table.insert(new_cards, copy_card(playing_card, nil, nil, G.playing_card))
			end
			G.E_MANAGER:add_event(Event({
				func = function()
					--TODO spawn in cards a bit nicer
					for _, playing_card in ipairs(new_cards) do
						playing_card:add_to_deck()
						playing_card:start_materialize()
						G.deck:emplace(playing_card)
						table.insert(G.playing_cards, playing_card)
					end
					playing_card_joker_effects(new_cards)
					return true
				end,
			}))
			Aiz.utils.status_text(context.blueprint_card or card, "k_duplicated_ex")
			G.E_MANAGER:add_event(Event({
				func = function()
					G.deck.config.card_limit = G.deck.config.card_limit + #new_cards
					return true
				end,
			}))

			draw_card(G.play, G.deck, 90, "up", nil)
			playing_card_joker_effects(new_cards)
		end
	end,
})
