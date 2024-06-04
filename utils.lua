function Create_blocking_card(card, position, silent)
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
end

-- Makes card polychrome even if it has another edition
function Turn_polychrome(card)
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
end
