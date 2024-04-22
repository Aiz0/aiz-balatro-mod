--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: JAIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers

----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.JAIZ()
	local loc_def = {
		["name"] = "Joker Test",
		["text"] = {
			[1] = "AHAHA",
			[2] = "Jokes on",
			[3] = "{C:attention}You{}!"
		}
	}

	-- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)
	local joker_test = SMODS.Joker:new("Joker Test", "test", {}, {
		x = 0,
		y = 0
	}, loc_def, 1, 4)

	SMODS.Sprite:new("j_test", SMODS.findModByID("JAIZ").path, "j_aha.png", 71, 95, "asset_atli"):register();

	joker_test:register()

	SMODS.Jokers.j_test.set_ability = function(self, context)
		sendDebugMessage("Hello !", 'MyLogger')
	end

	SMODS.Jokers.j_test.calculate = function(self, context)
		if SMODS.end_calculate_context(context) then
			return {
				mult_mod = 20,
				card = self,
				colour = G.C.RED,
				message = "AHAHAHAH"
			}
		end
	end
end

----------------------------------------------
------------MOD CODE END----------------------
