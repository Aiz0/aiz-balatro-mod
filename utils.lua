Aiz.utils = {
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

	--- Determines if any suit in suit_type is same as suit of playing_card
	---@param playing_card any Balatro Playing Card
	---@param suit_type string Dark | Light
	---@return boolean
	is_suit_type = function(playing_card, suit_type)
		-- stylua: ignore
		for suit, _ in pairs(Aiz.config.suits[suit_type]) do
			if playing_card:is_suit(suit) then
				return true
			end
		end
		return false
	end,

	get_random_suit_of_type = function(suit_type)
		-- returns key because value is meaningless
		return select(2, pseudorandom_element(Aiz.config.suits[suit_type], pseudoseed("random_suit")))
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

	--- Returns random key from table using weighted chance system
	---@param table {any: integer}
	---@param seed string
	---@return any key from **table**
	get_weighted_random = function(table, seed)
		local weight = 0
		for _, chance in pairs(table) do
			weight = weight + chance
		end
		local p = pseudorandom(seed and seed or "weighted_random", 1, weight)
		local cumulativeProbability = 0
		for key, probability in pairs(table) do
			cumulativeProbability = cumulativeProbability + probability
			if p <= cumulativeProbability then
				return key
			end
		end
	end,

	---uses string.format to round to 2 decimal places
	---@param exact number
	---@return number?
	round_2d = function(exact)
		return tonumber(string.format("%.2f", exact))
	end,
}
