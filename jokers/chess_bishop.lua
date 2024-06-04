SMODS.Joker({
	key = "chess_bishop",
	loc_txt = {
		name = "Bishop",
		text = {
			"Scored Numbered cards",
			"earn {C:money}$#1#{}",
			"Scored Face cards",
			"{C:attention}lose{} {C:money}$#1#{}",
		},
	},
	config = {
		extra = {
			money = 1,
		},
	},
	atlas = "jokers",
	pos = { y = 1, x = 0 },
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	-- makes sure this joker doesn't spawn in any pools
	yes_pool_flag = "this flag will never be set",

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,

	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local money = 0
			if context.other_card:is_face() then
				money = card.ability.extra.money * -1
			elseif context.other_card:get_id() >= 2 then
				money = card.ability.extra.money
			end
			if money ~= 0 then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.dollar_buffer = 0
						return true
					end,
				}))
				return {
					dollars = money,
					card = card,
				}
			end
		end
	end,
})
