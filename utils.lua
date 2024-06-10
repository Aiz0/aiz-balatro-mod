Aiz_utils = {
	create_blocking_card = function(card, position, silent)
		G.E_MANAGER:add_event(Event({
			func = function()
				-- create a new empty card
				-- TODO use SMODS.Center
				local blocking_card = Card(
					position.x,
					position.y,
					G.CARD_W,
					G.CARD_H,
					nil,
					G.P_CENTERS.c_base,
					{ playing_card = G.playing_card }
				)
				-- flip it manually so only back is shown
				blocking_card.facing = "back"
				blocking_card.sprite_facing = "back"
				-- Glue card in place to prevent it from being moved
				-- major needs to be set for start_materialize to work correctly
				blocking_card:set_role({ major = blocking_card, role_type = "Glued" })
				blocking_card:start_materialize(nil, silent)
				table.insert(card.ability.extra.cards, blocking_card)
				table.insert(card.ability.extra.card_positions, position)
				return true
			end,
		}))
	end,

	-- Makes card polychrome and lowers card limit for any negatives
	set_polychrome = function(card)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				if card.edition and card.edition.negative then
					if card.ability.consumeable then
						G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
					else
						G.jokers.config.card_limit = G.jokers.config.card_limit - 1
					end
				end
				card:set_edition({ polychrome = true }, true)
				return true
			end,
		}))
	end,

	flip_card_event = function(card)
		G.E_MANAGER:add_event(Event({
			delay = 0.25,
			trigger = "before",
			func = function()
				card:flip()
				play_sound("card1")
				card:juice_up(0.3, 0.3)
				return true
			end,
		}))
	end,

	suits = {
		light = {
			"Hearts",
			"Diamonds",
		},
		dark = {
			"Spades",
			"Clubs",
		},
	},
	get_suit_type = function(card_suit)
		for i, suit in ipairs(suits.dark) do
			if card_suit == suit then
				return "Dark"
			end
		end
		for i, suit in ipairs(suits.light) do
			if card_suit == suit then
				return "Light"
			end
		end
		return "Unknown"
	end,

	get_random_suit_of_type = function(suit_type)
		local choosen_type
		if suit_type == "Light" then
			choosen_type = suits.light
		else
			choosen_type = suits.dark
		end
		return pseudorandom_element(choosen_type, pseudoseed("random_suit"))
	end,

	eval_this = function(_card, eval_type, amount)
		if eval_type == "mult" then
			mult = mod_mult(mult + amount)
		end
		if eval_type == "chips" then
			hand_chips = mod_chips(hand_chips + amount)
		end
		if eval_type == "x_mult" then
			mult = mod_mult(mult * amount)
		end
		update_hand_text({ delay = 0 }, {
			chips = eval_type == "chips" and hand_chips,
			mult = (eval_type == "mult" or eval_type == "x_mult") and mult,
		})
		card_eval_status_text(_card, eval_type, amount, nil, nil, nil)
	end,
}
