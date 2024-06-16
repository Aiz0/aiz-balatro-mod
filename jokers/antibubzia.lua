-- AntiBubzia
-- Sets chips and mult to 0
-- if negative, squares chips and mult

SMODS.Joker({
	key = "antibubzia",
	loc_txt = {
		name = "AntiBubzia",
		text = {
			"Plays the exact",
			"same hand backwards",
			"to cancel out",
			"your score",
			"every {C:attention}freaking{} time",
		},
	},
	config = {},
	atlas = "jokers",
	pos = { y = 0, x = 3 },
	rarity = 3,
	cost = 10,
	blueprint_compat = false,

	set_ability = function(self, card)
		card.ability.eternal = true
	end,

	final_scoring_step = function(self, card, args)
		local text
		if card.edition and card.edition.negative then
			args.mult = args.mult * args.mult
			args.chips = args.chips * args.chips
			text = localize("k_aiz_squared")
		else
			args.mult = 0
			args.chips = 0
			text = localize("k_aiz_cancelled")
		end
		update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })

		-- mostly same effect as plasma deck.
		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 4.3,
			func = function()
				play_sound("gong", 0.94, 0.3)
				play_sound("gong", 0.94 * 1.5, 0.2)
				play_sound("tarot1", 1.5)
				attention_text({
					scale = 1.4,
					text = text,
					hold = 2,
					align = "cm",
					offset = { x = 0, y = -2.7 },
					major = G.play,
				})
				return true
			end,
		}))
		return args
	end,
})
