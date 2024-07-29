local config = SMODS.current_mod.config
SMODS.Joker({
	key = "kiki_bouba",
	loc_txt = {
		name = "Kiki/Bouba",
		text = {
			"{C:attention}Kiki{} Jokers",
			"each give {C:mult}+#1#{} Mult",
			"{C:attention}Bouba{} Jokers",
			"each give {C:chips}+#2#{} Chips",
		},
	},
	config = {
		extra = {
			mult = 6,
			chips = 30,
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 5 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
	end,

	calculate = function(self, card, context)
		if context.other_joker and context.other_joker.ability.set == "Joker" and context.other_joker ~= card then
			local is_kiki = config.is_kiki[context.other_joker.config.center_key]
			local eval, text, color = nil, nil, nil
			if is_kiki == nil then
				return
			elseif is_kiki then
				text = "k_aiz_kiki"
				color = G.C.MULT
				eval = {
					message = localize({
						type = "variable",
						key = "a_mult",
						vars = { card.ability.extra.mult },
					}),
					mult_mod = card.ability.extra.mult,
				}
			else
				text = "k_aiz_bouba"
				color = G.C.CHIPS
				eval = {
					message = localize({
						type = "variable",
						key = "a_chips",
						vars = { card.ability.extra.chips },
					}),
					chip_mod = card.ability.extra.chips,
				}
			end
			Aiz.utils.status_text(context.other_joker, text, color)
			return eval
		end
	end,
})
