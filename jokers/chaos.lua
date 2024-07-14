--TODO
-- random sounds during play
-- mess with speed
-- change sprite
-- force card to be selected
-- spawn blocking cards
-- shuffle scoring cards

SMODS.Joker({
	key = "chaos",
	loc_txt = {
		name = "Chaos",
		text = {
			"Cards are scored in random order",
			"{C:green}#1# in #2#{} for {C:chips}+100{} Chips",
			"{C:green}#1# in #3#{} for {C:mult}+20{} Mult",
			"{C:green}#1# in #4#{} for {X:mult,C:white}X3{} Mult",
			"At start of round:",
			"{C:green}#1# in #5#{} to flip Jokers",
			"{C:green}#1# in #6#{} to shuffle Jokers",
			"{C:green}#1# in #7#{} to increase this Jokers {C:green,E:1,S:1.1}Probabilities",
			"{C:green}#1# in #8#{} to {C:attention}Double{} all listed {C:green,E:1,S:1.1}Probabilities",
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
				increase_odds = 50,
				double_all_odds = 1000,
			},
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
	end,
})
