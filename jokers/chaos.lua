--TODO
-- random sounds during play
-- mess with speed
-- change sprite

SMODS.Joker({
	key = "chaos",
	loc_txt = {
		name = "Chaos",
		text = {
			"Cards are scored in random order",
			"{C:green}#1# in #9#{} to force 1 card to be selected",
			"{C:green}#1# in #2#{} for {C:chips}+100{} Chips",
			"{C:green}#1# in #3#{} for {C:mult}+20{} Mult",
			"{C:green}#1# in #4#{} for {X:mult,C:white}X3{} Mult",
			"At start of round:",
			"{C:green}#1# in #5#{} to flip Jokers",
			"{C:green}#1# in #6#{} to shuffle Jokers",
			"{C:green}#1# in #7#{} to increase this Jokers {C:green,E:1,S:1.1}Probabilities",
			"{C:green}#1# in #8#{} to {C:attention}Double{} all listed {C:green,E:1,S:1.1}Probabilities",
			"{C:green}#1# in #9#{} to {C:attention}Block{} Run Info",
		},
	},
	config = {
		extra = {
			probability = 1,
			odds = {
				chips = 2,
				mult = 4,
				Xmult = 8,
				flip = 5,
				shuffle = 10,
				forced_card = 10,
				increase_odds = 15,
				double_all_odds = 1000,
				blocking = 10,
			},
			blocking = { cards = {}, positions = {} },
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 1 },
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
				card.ability.extra.odds.flip,
				card.ability.extra.odds.shuffle,
				card.ability.extra.odds.increase_odds,
				card.ability.extra.odds.double_all_odds,
				card.ability.extra.odds.forced_card,
				card.ability.extra.odds.blocking,
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
				Aiz.utils.status_text(context.blueprint_card or card, "k_aiz_odds_increased")
			end
			if chaos_random(card.ability.extra.odds.double_all_odds) then
				for k, v in pairs(G.GAME.probabilities) do
					G.GAME.probabilities[k] = v * 2
				end
				Aiz.utils.status_text(context.blueprint_card or card, "k_aiz_odds_doubled")
			end

			if chaos_random(card.ability.extra.odds.flip) then
				Aiz.utils:flip_jokers()
			end
			if chaos_random(card.ability.extra.odds.shuffle) then
				Aiz.utils:shuffle_jokers(false, true)
			end
			if chaos_random(card.ability.extra.odds.blocking) then
				Aiz.utils.create_blocking_card(card, { x = -0.5, y = 7 }, false)
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
		end

		-- end of round remove blocking cards
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			-- TODO move this logic to blocking cards themselves or something
			for i, blocking_card in ipairs(card.ability.extra.blocking.cards) do
				blocking_card:start_dissolve(nil, i ~= #card.ability.extra.blocking.cards)
			end
			-- needs to be reset manually
			card.ability.extra.blocking.positions = {}
		end
	end,

	-- custom function called by code injected at Game:update_draw_to_hand
	drawn_to_hand = function(self, card)
		if
			pseudorandom("aiz_chaos")
			< (G.GAME.probabilities.normal * card.ability.extra.probability) / card.ability.extra.odds.forced_card
		then
			local any_forced = nil
			for k, v in ipairs(G.hand.cards) do
				if v.ability.forced_selection then
					any_forced = true
				end
			end
			if not any_forced then
				G.hand:unhighlight_all()
				local forced_card = pseudorandom_element(G.hand.cards, pseudoseed("aiz_chaos"))
				forced_card.ability.forced_selection = true
				G.hand:add_to_highlighted(forced_card)
			end
		end
	end,

	load = function(self, card, card_table, other_card)
		Aiz.utils.load_blocking_cards(card, card_table)
	end,
})
