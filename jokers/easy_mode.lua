SMODS.Joker({
	key = "easy_mode",
	loc_txt = {
		name = "Easy Mode",
		text = {
			"Gives {C:mult}+1 mult{} for",
			"every 2 jokers with",
			"{C:attention}White stickers{}",
			"in your collection",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			mult_mod = 0.5,
			sticker = "white",
		},
	},
	atlas = "jokers",
	pos = { y = 5, x = 0 },
	rarity = 2,
	cost = 7,
	blueprint_compat = true,

	get_mult = function(card)
		local mult = 0
		sendDebugMessage(card.ability.extra.sticker)
		-- Add mult for every sticker matching
		for _, v in pairs(G.P_CENTERS) do
			if v.set == "Joker" then
				sendDebugMessage(get_joker_win_sticker(v, false))
				if get_joker_win_sticker(v, false) == card.ability.extra.sticker then
					mult = mult + card.ability.extra.mult_mod
				end
			end
		end
		return math.floor(mult)
	end,

	loc_vars = function(self, info_queue, card)
		return { vars = { self.get_mult(card) } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_mult",
					vars = { self.get_mult(card) },
				}),
				mult_mod = self.get_mult(card),
			}
		end
	end,
})
