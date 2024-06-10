SMODS.Joker({
	key = "chess_knight",
	loc_txt = {
		name = "Knight",
		text = {
			"Converts scored {C:attention}#2#{} suits",
			"To random {C:attention}#3#{} suits",
			"Give {C:mult}+#1#{} Mult for each",
			"converted card in played hand",
			"{s:0.8}Flips order after conversion{}",
		},
	},
	config = {
		extra = {
			mult = 0,
			mult_mod = 10,
			change = {
				from = "Dark",
				to = "Light",
			},
		},
	},
	atlas = "jokers",
	pos = { y = 9, x = 0 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	-- makes sure this joker doesn't spawn in any pools
	yes_pool_flag = "this flag will never be set",

	--TODO localization for suit colors
	--TODO use dark/light color for text instead of attention.
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod, card.ability.extra.change.from, card.ability.extra.change.to } }
	end,

	set_ability = function(self, card)
		-- Randomize starting suits.
		-- Partially just to make it easier to have multiple knights be useful together.
		local change_to_light = (0.5 > pseudorandom("knight_suits"))
		card.ability.extra.change.from = (change_to_light and "Dark" or "Light")
		card.ability.extra.change.to = (change_to_light and "Light" or "Dark")
	end,

	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.before and not context.blueprint then
			-- Reset mult every round
			card.ability.extra.mult = 0
			-- table used so i don't have to do the check twice
			local converted_cards = {}
			-- Flip cards and calculate mult
			for _, playing_card in ipairs(context.scoring_hand) do
				if Aiz_utils.get_suit_type(playing_card.base.suit) == card.ability.extra.change.from then
					Flip_card_event(playing_card)
					table.insert(converted_cards, playing_card)
				end
			end
			-- Change suit and flip cards back
			for _, playing_card in ipairs(converted_cards) do
				local new_suit = Aiz_utils.get_random_suit_of_type(card.ability.extra.change.to)
				playing_card.base.suit = new_suit
				G.E_MANAGER:add_event(Event({
					delay = 0.15,
					trigger = "after",
					func = function()
						playing_card:change_suit(new_suit)
						return true
					end,
				}))
				Flip_card_event(playing_card)
			end
			if #converted_cards > 0 then
				-- Calculate mult this round
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * #converted_cards
				-- flip conversion
				card.ability.extra.change.from, card.ability.extra.change.to =
					card.ability.extra.change.to, card.ability.extra.change.from
				return {
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { card.ability.extra.mult },
					}),
					colour = G.C.MULT,
					card = card,
				}
			end
		end

		-- I gave up and seperated card conversion and mult giving into 2 steps.
		-- This is why blueprint won't convert cards anymore
		if context.joker_main then
			if card.ability.extra.mult > 0 then
				return {
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { card.ability.extra.mult },
					}),
					mult_mod = card.ability.extra.mult,
				}
			end
		end
	end,
})
