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
		local joker_loud = SMODS.Joker:new("Loud Joker", "loud", {},
			nil,
			{
				name = "Loud joker",
				text = {
					"Gives {C:chips}Chips{} equal to volume ",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
				}
			}, 1, 4)
		joker_loud:register()
		local function joker_loud_chips()
			return math.floor((G.SETTINGS.SOUND.music_volume + G.SETTINGS.SOUND.game_sounds_volume) *
				G.SETTINGS.SOUND.volume / 100)
		end

		SMODS.Jokers.j_loud.loc_def = function(card)
			return { joker_loud_chips() }
		end


		SMODS.Jokers.j_loud.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					chip_mod = joker_loud_chips(),
					card = card,
					message = localize { type = 'variable', key = 'a_chips', vars = { joker_loud_chips() } }
				}
			end
		end


		local joker_easy_mode = SMODS.Joker:new("Easy mode", "easy_mode", {},
			nil,
			{
				name = "Easy mode",
				text = {
					"Gives {C:mult}+1 mult{} for",
					"every 2 jokers with ",
					"{C:attention}White stickers{} in your collection",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
				}
			}, 1, 4)
		joker_easy_mode:register()

		local function joker_easy_mode_mult()
			local mult = 0
			-- Add mult for every white sticker on a joker
			for _, v in pairs(G.P_CENTERS) do
				if v.set == 'Joker' then
					if get_joker_win_sticker(v, false) == "White" then
						mult = mult + 0.5
					end
				end
			end
			return math.floor(mult)
		end

		SMODS.Jokers.j_easy_mode.loc_def = function(card)
			return { joker_easy_mode_mult() }
		end


		SMODS.Jokers.j_easy_mode.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					mult_mod = joker_easy_mode_mult(),
					card = card,
					message = localize { type = 'variable', key = 'a_mult', vars = { joker_easy_mode_mult() } }
				}
			end
		end
		local joker_shark = SMODS.Joker:new("Aiz Blåhaj", "aiz_blåhaj", { extra = { j_slots = 1 } },
			nil,
			{
				name = "Blåhaj",
				text = {
					"A soft toy shark",
					"{C:dark_edition}+#1#{} Joker slots"
				}
			}, 1, 4)

		joker_shark:register()
	end
	SMODS.Jokers.j_aiz_blåhaj.loc_def = function(card)
		return { card.ability.extra.j_slots }
	end
end

-- Handle card addition/removing
local add_to_deckref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
	if not self.added_to_deck then
		if self.ability.name == "Aiz Blåhaj" then
			G.jokers.config.card_limit = G.jokers.config.card_limit + self.ability.extra.j_slots
		end
	end
	add_to_deckref(self, from_debuff)
end

local remove_from_deckref = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	if self.added_to_deck then
		if self.ability.name == "Aiz Blåhaj" then
			G.jokers.config.card_limit = G.jokers.config.card_limit - self.ability.extra.j_slots
		end
	end
	remove_from_deckref(self, from_debuff)
end

----------------------------------------------
------------MOD CODE END----------------------
