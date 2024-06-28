SMODS.Joker({
	key = "tinkerer",
	loc_txt = {
		name = "Tinkerer",
		text = {
			"{X:mult,C:white}X#1#{} Mult for each",
			"{C:attention}Mod{} you have {C:attention}Active{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
		},
	},
	config = {
		extra = {
			Xmult_mod = 0.1,
			Xmult = 1,
			cost_mod = 4,
		},
	},
	atlas = "jokers",
	pos = { y = 2, x = 2 },
	rarity = 2,
	cost = 0,
	blueprint_compat = true,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,

	set_ability = function(self, card)
		local xmult = card.ability.extra.Xmult
		for _, modInfo in ipairs(SMODS.mod_list) do
			if modInfo.can_load and not modInfo.disabled then
				xmult = xmult + card.ability.extra.Xmult_mod
			end
		end
		card.ability.extra.Xmult = xmult
		-- cost is based on how powerful it is
		card.base_cost = card.base_cost + card.ability.extra.cost_mod * xmult
		card:set_cost()
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize({
					type = "variable",
					key = "a_xmult",
					vars = { card.ability.extra.Xmult },
				}),
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end,
})
