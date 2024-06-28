SMODS.Joker({
	key = "ultimate_unknown",
	loc_txt = {
		name = "Ultimate ???",
		text = {
			"{C:mult}+#1#{} Mult for each unique enhancement",
			"{X:mult,C:white}X#2#{} Mult for each unique edition",
			"{C:chips}+#3#{} Chips for each unique seal",
			"In your Full Deck",
			"{C:inactive}(Currently {C:mult}+#4#{C:inactive}, {X:mult,C:white}X#5#{C:inactive}, {C:chips}+#6#{C:inactive})",
		},
	},
	config = {
		extra = {
			chip_mod = 25,
			mult_mod = 5,
			Xmult_mod = 0.2,
		},
	},
	atlas = "jokers_soul",
	pos = { y = 1, x = 2 },
	soul_pos = { y = 1, x = 3 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	---returns mult xmult and chips joker should give
	---@param self any
	---@param card any
	---@return integer enhancement * mult
	---@return integer editions * xmult
	---@return integer
	get_evals = function(self, card)
		local enhancement_count, edition_count, seal_count = 0, 0, 0
		if G.playing_cards ~= nil then
			local enhancements, editions, seals = {}, {}, {}
			for i, playing_card in ipairs(G.playing_cards) do
				if playing_card.edition and editions[playing_card.edition.type] == nil then
					editions[playing_card.edition.type] = true
					edition_count = edition_count + 1
				end
				if
					playing_card.config.center ~= G.P_CENTERS.c_base
					and enhancements[playing_card.config.center] == nil
				then
					enhancements[playing_card.config.center] = true
					enhancement_count = enhancement_count + 1
				end
				if playing_card.seal ~= nil and seals[playing_card.seal] == nil then
					seals[playing_card.seal] = true
					seal_count = seal_count + 1
				end
			end
		end
		return enhancement_count * card.ability.extra.mult_mod,
			edition_count * card.ability.extra.Xmult_mod + 1,
			seal_count * card.ability.extra.chip_mod
	end,

	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_mod,
				card.ability.extra.Xmult_mod,
				card.ability.extra.chip_mod,
				self:get_evals(card),
			},
		}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local mult_mod, Xmult_mod, chip_mod = self:get_evals(card)
			Aiz.utils.eval_this(context.blueprint_card or card, "mult", mult_mod)
			Aiz.utils.eval_this(context.blueprint_card or card, "x_mult", Xmult_mod)
			Aiz.utils.eval_this(context.blueprint_card or card, "chips", chip_mod)
		end
	end,
})
