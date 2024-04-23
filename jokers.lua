--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: JAIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers

----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.JAIZ()
	local enabled = true
	if enabled then
		-- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)
		local joker_test = SMODS.Joker:new("Joker Test", "test", { extra = { Xmult = 1, Xmult_mod = 0.1 } }, {
			x = 0,
			y = 0
		}, {
			name = "BLJ",
			text = {
				"This Joker gains {X:mult,C:white}X#2#{} Mult if",
				"a card is triggered during scoring",
				"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
			}
		}, 1, 4)

		SMODS.Sprite:new("j_test", SMODS.findModByID("JAIZ").path, "j_aha.png", 71, 95, "asset_atli"):register();

		joker_test:register()

		SMODS.Jokers.j_test.loc_def = function(card)
			return { card.ability.extra.Xmult, card.ability.extra.Xmult_mod }
		end

		SMODS.Jokers.j_test.calculate = function(card, context)
			if context.individual then
				if context.cardarea == G.play or context.cardarea == G.hand then
					card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
					return {
						extra = { focus = card, message = "Yahoooo!!!" },
						card = card,
						colour = G.C.RED
					}
				end
			elseif SMODS.end_calculate_context(context) and card.ability.extra.Xmult > 1 then
				return {
					Xmult_mod = card.ability.extra.Xmult,
					card = card,
					colour = G.C.mult,
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
				}
			end
		end


		local joker_chill = SMODS.Joker:new("Chill Joker", "chill", { extra = { Xmult = 4 } },
			{ x = 0, y = 0 },
			{
				name = "Chill joker",
				text = {
					"{X:mult,C:white}X#1#{} divided by game speed",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			}, 1, 4)
		SMODS.Sprite:new("j_chill", SMODS.findModByID("JAIZ").path, "j_aha.png", 71, 95, "asset_atli"):register();
		joker_chill:register()

		SMODS.Jokers.j_chill.loc_def = function(card)
			return { card.ability.extra.Xmult, card.ability.extra.Xmult / G.SETTINGS.GAMESPEED }
		end
		SMODS.Jokers.j_chill.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				local Xmult = card.ability.extra.Xmult / G.SETTINGS.GAMESPEED
				return {
					Xmult_mod = Xmult,
					card = card,
					colour = G.C.mult,
					message = localize { type = 'variable', key = 'a_xmult', vars = { Xmult } }
				}
			end
		end
	end
end

----------------------------------------------
------------MOD CODE END----------------------
