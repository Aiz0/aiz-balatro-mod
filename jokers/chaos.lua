SMODS.Joker({
	key = "Chaos",
	loc_txt = {
		name = "Chaos",
		text = {
			"{C:green}#1# in #2#{} for {C:chips}+100{} Chips",
			"{C:green}#1# in #3#{} for {C:mult}+20{} Mult",
			"{C:green}#1# in #4#{} for {X:mult,C:white}X3{} Mult",
			"{C:green}#1# in #5#{} for {C:money}$10",
			"{C:green}#1# in #6#{} for a {C:tarot}Tarot{} Card",
			"{C:green}#1# in #7#{} for a {C:planet}Planet{} Card",
			"{C:green}#1# in #8#{} for a {C:dark_edition}Spectral{} Card",
			"At start of round:",
			"{C:green}#1# in #9#{} for a Playing Card",
			"{C:green}#1# in #10#{} to flip and shuffle Jokers",
			"{C:green}#1# in #11#{} to {C:red}Destroy{} a random Joker",
			"{C:green}#1# in #12#{} to {C:attention}Create{} a random Joker",
			"{C:green}#1# in #13#{} to increase this Jokers {C:green,E:1,S:1.1}Probabilities",
			"{C:green}#1# in #14#{} to {C:attention}Double{} all listed {C:green,E:1,S:1.1}Probabilities",
		},
	},
	config = {
		extra = {
			probability = 1,
			odds = {
				chips = 2,
				mult = 4,
				Xmult = 8,
				dollars = 15,
				joker = 10,
				tarot = 10,
				planet = 10,
				spectral = 20,
				playing_card = 2,
				shuffle = 10,
				destroy_joker = 20,
				increase_odds = 50,
				double_all_odds = 1000,
			},
		},
	},
	atlas = "jokers",
	pos = { y = 3, x = 0 },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				(G.GAME and G.GAME.probabilities.normal or 1) * card.ability.extra.probability,
				card.ability.extra.odds.chips,
				card.ability.extra.odds.mult,
				card.ability.extra.odds.Xmult,
				card.ability.extra.odds.dollars,
				card.ability.extra.odds.tarot,
				card.ability.extra.odds.planet,
				card.ability.extra.odds.spectral,
				card.ability.extra.odds.playing_card,
				card.ability.extra.odds.shuffle,
				card.ability.extra.odds.destroy_joker,
				card.ability.extra.odds.joker,
				card.ability.extra.odds.increase_odds,
				card.ability.extra.odds.double_all_odds,
			},
		}
	end,

	calculate = function(self, card, context)
		local function chaos_random(odds)
			return pseudorandom("aiz_chaos") < (G.GAME.probabilities.normal * card.ability.extra.probability) / odds
		end
		-- Start of round
		if context.first_hand_drawn then
			if not context.blueprint and chaos_random(card.ability.extra.odds.increase_odds) then
				card.ability.extra.probability = card.ability.extra.probability + 1
				card_eval_status_text((context.blueprint_card or card), "extra", nil, nil, nil, {
					message = "probability increased",
				})
			end
			if chaos_random(card.ability.extra.odds.double_all_odds) then
				for k, v in pairs(G.GAME.probabilities) do
					G.GAME.probabilities[k] = v * 2
				end
				card_eval_status_text((context.blueprint_card or card), "extra", nil, nil, nil, {
					message = "Probabilities doubled",
				})
			end
			-- Copied from Certificate
			if chaos_random(card.ability.extra.odds.playing_card) then
				G.E_MANAGER:add_event(Event({
					func = function()
						local new_playing_card = create_playing_card({
							front = pseudorandom_element(G.P_CARDS, pseudoseed("aiz_chaos")),
							center = G.P_CENTERS.c_base,
						}, G.hand, nil, nil, { G.C.SECONDARY_SET.Enhanced })

						G.GAME.blind:debuff_card(new_playing_card)
						G.hand:sort()
						if context.blueprint_card then
							context.blueprint_card:juice_up()
						else
							card:juice_up()
						end
						return true
					end,
				}))
				playing_card_joker_effects({ true })
			end

			if chaos_random(card.ability.extra.odds.shuffle) then
				G.jokers:unhighlight_all()
				for k, v in ipairs(G.jokers.cards) do
					v:flip()
				end
				if #G.jokers.cards > 1 then
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 0.2,
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									G.jokers:shuffle("aajk")
									play_sound("cardSlide1", 0.85)
									return true
								end,
							}))
							delay(0.15)
							G.E_MANAGER:add_event(Event({
								func = function()
									G.jokers:shuffle("aajk")
									play_sound("cardSlide1", 1.15)
									return true
								end,
							}))
							delay(0.15)
							G.E_MANAGER:add_event(Event({
								func = function()
									G.jokers:shuffle("aajk")
									play_sound("cardSlide1", 1)
									return true
								end,
							}))
							delay(0.5)
							return true
						end,
					}))
				end
			end
			-- Destroy Card
			-- Copied from Madness
			if not context.blueprint and chaos_random(card.ability.extra.odds.destroy_joker) then
				local destructable_jokers = {}
				for i = 1, #G.jokers.cards do
					if
						G.jokers.cards[i] ~= card
						and not G.jokers.cards[i].ability.eternal
						and not G.jokers.cards[i].getting_sliced
					then
						destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
					end
				end
				local joker_to_destroy = #destructable_jokers > 0
						and pseudorandom_element(destructable_jokers, pseudoseed("aiz_chaos"))
					or nil

				if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then
					joker_to_destroy.getting_sliced = true
					G.E_MANAGER:add_event(Event({
						func = function()
							(context.blueprint_card or card):juice_up(0.8, 0.8)
							joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
							return true
						end,
					}))
				end
				if not (context.blueprint_card or card).getting_sliced then
					card_eval_status_text((context.blueprint_card or card), "extra", nil, nil, nil, {
						message = localize("k_aiz_destroy"),
					})
				end
			end
			-- Random Joker
			if
				chaos_random(card.ability.extra.odds.joker)
				and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
			then
				-- Modified from Riff Raff code
				G.GAME.joker_buffer = G.GAME.joker_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						local new_joker = create_card("Joker", G.jokers, nil, nil, nil, nil, nil, "aiz_chaos")
						new_joker:add_to_deck()
						G.jokers:emplace(new_joker)
						new_joker:start_materialize()
						G.GAME.joker_buffer = 0
						return true
					end,
				}))
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_plus_joker"), colour = G.C.BLUE }
				)
			end
		end

		-- At Scoring
		if context.joker_main then
			-- Chips
			if chaos_random(card.ability.extra.odds.chips) then
				Aiz.utils.eval_this(context.blueprint_card or card, "chips", 100)
			end
			-- Mult
			if chaos_random(card.ability.extra.odds.mult) then
				Aiz.utils.eval_this(context.blueprint_card or card, "mult", 20)
			end
			-- Xmult
			if chaos_random(card.ability.extra.odds.Xmult) then
				Aiz.utils.eval_this(context.blueprint_card or card, "x_mult", 3)
			end
			-- Money
			if chaos_random(card.ability.extra.odds.dollars) then
				ease_dollars(10)
				card_eval_status_text(context.blueprint_card or card, "dollars", 10, nil, nil, nil)
			end

			-- Random Tarot
			if
				chaos_random(card.ability.extra.odds.tarot)
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				-- Modified from Hallucination code
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.0,
					func = function()
						local new_tarot = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "aiz_chaos")
						new_tarot:add_to_deck()
						G.consumeables:emplace(new_tarot)
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_plus_tarot"), colour = G.C.PURPLE }
				)
			end
			-- Random planet
			if
				chaos_random(card.ability.extra.odds.tarot)
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				-- Modified from Hallucination code
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.0,
					func = function()
						local new_tarot = create_card("Planet", G.consumeables, nil, nil, nil, nil, nil, "aiz_chaos")
						new_tarot:add_to_deck()
						G.consumeables:emplace(new_tarot)
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_plus_planet"), colour = G.C.SECONDARY_SET.Planet }
				)
			end
			-- Random spectral
			if
				chaos_random(card.ability.extra.odds.spectral)
				and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			then
				-- Modified from Hallucination code
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.0,
					func = function()
						local new_tarot = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "aiz_chaos")
						new_tarot:add_to_deck()
						G.consumeables:emplace(new_tarot)
						G.GAME.consumeable_buffer = 0
						return true
					end,
				}))
				card_eval_status_text(
					context.blueprint_card or card,
					"extra",
					nil,
					nil,
					nil,
					{ message = localize("k_plus_spectral"), colour = G.C.SECONDARY_SET.Spectral }
				)
			end
		end
	end,
})
