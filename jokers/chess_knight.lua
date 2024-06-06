SMODS.Joker({
	key = "chess_knight",
	loc_txt = {
		name = "Knight",
		text = {
			"Converts scored {C:attention}#2#{} suits",
			"To random {C:attention}#3#{} suits",
			"Converted cards give {C:mult}+#1#{} Mult",
			"{s:0.8}Flips conversion at end of round{}",
		},
	},
	config = {
		extra = {
			mult = 10,
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

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.change.from, card.ability.extra.change.to } }
	end,

	set_ability = function(self, card)
		-- Randomize starting suits.
		-- Partially just to make it easier to have multiple knights be useful together.
		local change_to_light = (0.5 > pseudorandom("knight_suits"))
		card.ability.extra.change.from = (change_to_light and "Dark" or "Light")
		card.ability.extra.change.to = (change_to_light and "Light" or "Dark")
	end,

	card_can_be_converted = function(card, other_card)
		-- just checks if current suit is the type that should be converted
		return (
			((other_card.aiz_knight_suit == other_card.base.suit) or not other_card.aiz_knight_suit)
			and Get_suit_type(other_card.base.suit) == card.ability.extra.change.from
		)
			or (
				other_card.aiz_knight_suit ~= other_card.base.suit
				and Get_suit_type(other_card.aiz_knight_suit) == card.ability.extra.change.from
			)
	end,

	calculate = function(self, card, context)
		-- TODO make actual suit change during calculation instead of using a temp property
		if context.individual and context.cardarea == G.play then
			if self.card_can_be_converted(card, context.other_card) then
				-- Get new suit and add it to a new property so that multiple knights can work together
				local new_suit = Get_random_suit_of_type(card.ability.extra.change.to)
				context.other_card.aiz_knight_suit = new_suit

				Flip_card_event(context.other_card)
				G.E_MANAGER:add_event(Event({
					delay = 0.15,
					trigger = "after",
					func = function()
						-- after setting suit we also need to reset knight suit
						context.other_card:change_suit(new_suit)
						context.other_card.aiz_knight_suit = nil
						return true
					end,
				}))
				Flip_card_event(context.other_card)
				return {
					mult = card.ability.extra.mult,
					card = card,
				}
			end
		end
		-- TODO only change suit if cards got flipped
		-- flip suit to change at end of round
		if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
			local temp = card.ability.extra.change.from
			card.ability.extra.change.from = card.ability.extra.change.to
			card.ability.extra.change.to = temp
		end
	end,
})
