SMODS.Joker({
	key = "chess_pawn_storm",
	loc_txt = {
		name = "Pawn Storm",
		text = {
			"When blind is selected,",
			"if you have no Pawns",
			"create {C:attention}#1# Pawns",
			"{C:inactive}(Must have room){}",
		},
	},
	config = {
		extra = {
			pawns = 2,
		},
	},
	-- TODO: add texture
	--atlas = "jokers",
	--pos = { y = 2, x = 0 },
	rarity = 2,
	cost = 9,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.pawns } }
	end,

	calculate = function(self, card, context)
		-- Basically Riff-Raff for pawns
		if
			context.setting_blind
			and not context.blueprint
			and not card.getting_sliced
			and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
			and not next(SMODS.find_card("j_aiz_chess_pawn"))
		then
			local jokers_to_create =
				math.min(card.ability.extra.pawns, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
			G.E_MANAGER:add_event(Event({
				func = function()
					for i = 1, jokers_to_create do
						local new_joker = create_card("Joker", G.jokers, nil, 0, nil, nil, "j_aiz_chess_pawn", "rif")
						new_joker:add_to_deck()
						G.jokers:emplace(new_joker)
						new_joker:start_materialize()
						G.GAME.joker_buffer = 0
					end
					return true
				end,
			}))
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = localize("k_plus_joker"), colour = G.C.BLUE }
			)
		end
	end,
})
