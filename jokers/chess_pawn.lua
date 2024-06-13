-- Chess pawn
-- After a few rounds it promotes to a different chess joker

SMODS.Joker({
	key = "chess_pawn",
	loc_txt = {
		name = "Pawn",
		text = {
			"Advances at end of round",
			"Adds current rank to mult",
			"{C:inactive}(Currently on rank {C:attention}#1#{C:inactive})",
		},
	},
	config = {
		extra = {
			rank = 2,
			promotion_rank = 8,
		},
	},
	atlas = "jokers",
	pos = { y = 11, x = 0 },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rank } }
	end,

	---Returns key of a random joker from table **Aiz.config.pawn_promotion**
	---@return string
	get_promotion_joker = function()
		-- Remove any jokers that aren't registered
		-- Prevents crash from trying to create non existent jokers
		local available_jokers = {}
		for k, v in pairs(Aiz.config.pawn.promotion) do
			for _, center in pairs(G.P_CENTERS) do
				if center.set == "Joker" then
					if k == center.key then
						available_jokers[k] = v
					end
				end
			end
		end

		-- Check owned jokers and reduce weight to prevent duplicates
		for i = 1, #G.jokers.cards do
			for key, probability in pairs(available_jokers) do
				if G.jokers.cards[i].config.center.key == key then
					available_jokers[key] = probability * Aiz.config.pawn.duplicate_chance_reduction
				end
			end
		end

		return Aiz.utils.get_weighted_random(available_jokers, "random_chess_joker")
	end,

	calculate = function(self, card, context)
		-- Just give mult
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { card.ability.extra.rank },
				}),
				mult_mod = card.ability.extra.rank,
			}
		end

		-- should increment rank and show appropate message
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			-- This should simulate advancing 2 ranks on first move
			local advances = (card.ability.extra.rank == 2) and 2 or 1
			card.ability.extra.rank = card.ability.extra.rank + advances
			if card.ability.extra.rank < card.ability.extra.promotion_rank then
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize("k_aiz_advance"),
				})
			else
				-- shake card
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize("k_aiz_promoted"),
				})

				G.E_MANAGER:add_event(Event({
					func = function()
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
								-- Get current edition and add it to newly created joker
								local edition = card.edition
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								local joker_slug = self.get_promotion_joker()
								local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, joker_slug, nil)
								new_card:set_edition(edition, nil, true)
								new_card:add_to_deck()
								G.jokers:emplace(new_card)
								return true
							end,
						}))
						return true
					end,
				}))
			end
		end
	end,
})
