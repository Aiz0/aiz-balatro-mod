--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: JAIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers

----------------------------------------------
------------MOD CODE -------------------------

-- Config: DISABLE UNWANTED MODS HERE
local config = {
	-- Categories
	allEnabled = true,
	jokersEnabled = true,
	-- Jokers
	backwardsLongJump = true,
	chillJoker = true,
	loudspeaker = true,
	easyMode = true,
	antiBubzia = true,
	blåhaj = true,
}

-- Helper functions
-- Copied from Mikas Mod Collection
-- https://github.com/MikaSchoenmakers/MikasBalatro/tree/main

local function init_joker(joker, no_sprite)
	no_sprite = no_sprite or false

	local new_joker = SMODS.Joker:new(
		joker.ability_name,
		joker.slug,
		joker.ability,
		{ x = 0, y = 0 },
		joker.loc,
		joker.rarity,
		joker.cost,
		joker.unlocked,
		joker.discovered,
		joker.blueprint_compat,
		joker.eternal_compat,
		joker.effect,
		joker.atlas,
		joker.soul_pos
	)
	new_joker:register()

	if not no_sprite then
		local sprite = SMODS.Sprite:new(
			new_joker.slug,
			SMODS.findModByID("MikasMods").path,
			new_joker.slug .. ".png",
			71,
			95,
			"asset_atli"
		)
		sprite:register()
	end
end


function Jokers()
	if config.chillJoker then
		-- Chill Joker
		-- Gives Xmult based on gamespeed

		-- Create Joker
		local chill_joker = {
			loc = {
				name = "Chill Joker",
				text = {
					"{X:mult,C:white}X#1#{} divided by game speed",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			ability_name = "AIZ Chill Joker",
			slug = "aiz_chill",
			ability = {
				extra = {
					Xmult = 4
				}
			},
			rarity = 1,
			cost = 4,
			unlocked = true,
			discovered = true,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(chill_joker, true)

		-- Set local variables
		SMODS.Jokers.j_aiz_chill.loc_def = function(card)
			return { card.ability.extra.Xmult, card.ability.extra.Xmult / G.SETTINGS.GAMESPEED }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_chill.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				-- Get current gamespeed and give Xmult based on that
				local Xmult = card.ability.extra.Xmult / G.SETTINGS.GAMESPEED
				return {
					message = localize {
						type = 'variable', key = 'a_xmult', vars = { Xmult }
					},
					Xmult_mod = Xmult,
				}
			end
		end
	end

	if config.loudspeaker then
		-- Loudspeaker
		-- Gives Chips based on Audio volume

		-- Create Joker
		local loudspeaker = {
			loc = {
				name = "Loudspeaker",
				text = {
					"Gives {C:chips}Chips{} based ",
					"on {C:attention}Audio volume{}",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
				}
			},
			ability_name = "AIZ Loudspeaker",
			slug = "aiz_loudspeaker",
			ability = {
				extra = {

				}
			},
			rarity = 1,
			cost = 4,
			unlocked = true,
			discovered = true,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(loudspeaker, true)

		-- custom function
		local function get_loudspeaker_chips()
			return math.floor((G.SETTINGS.SOUND.music_volume + G.SETTINGS.SOUND.game_sounds_volume) *
				G.SETTINGS.SOUND.volume / 100)
		end

		-- Set local variables
		SMODS.Jokers.j_aiz_loudspeaker.loc_def = function(card)
			return { get_loudspeaker_chips() }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_loudspeaker.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					message = localize {
						type = 'variable',
						key = 'a_chips',
						vars = { get_loudspeaker_chips() }
					},
					chip_mod = get_loudspeaker_chips(),
				}
			end
		end
	end

	if config.easyMode then
		-- Get +mult for each joker with a specific stake sticker
		-- sticker has to be that specific type.

		-- Create Joker
		local easyMode = {
			loc = {
				name = "Easy Mode",
				text = {
					"Gives {C:mult}+1 mult{} for",
					"every 2 jokers with ",
					"{C:attention}White stickers{} in your collection",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
				}
			},
			ability_name = "AIZ Easy Mode",
			slug = "aiz_",
			ability = {
				extra = {
					mult_mod = 0.5,
					sticker = "White"
				}
			},
			rarity = 1,
			cost = 4,
			unlocked = true,
			discovered = true,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(easyMode, true)

		local function get_easy_mode_mult(card)
			local mult = 0
			-- Add mult for every white sticker on a joker
			for _, v in pairs(G.P_CENTERS) do
				if v.set == 'Joker' then
					if get_joker_win_sticker(v, false) == card.ability.extra.sticker then
						mult = mult + card.ability.extra.mult_mod
					end
				end
			end
			return math.floor(mult)
		end


		-- Set local variables
		SMODS.Jokers.j_aiz_easy_mode.loc_def = function(card)
			return { get_easy_mode_mult(card) }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_easy_mode.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				local mult_mod = get_easy_mode_mult(card)
				return {
					message = localize {
						type = 'variable',
						key = 'a_mult',
						vars = { mult_mod }
					},
					mult_mod = mult_mod,
				}
			end
		end
	end

	if config.blåhaj then
		-- Blåhaj
		-- Does nothing by itself since it just gives +1 joker slot
		-- Has code in Card:add_to_deck & Card:remove_from_deck

		-- Create Joker
		local blåhaj = {
			loc = {
				name = "Blåhaj",
				text = {
					"A soft toy shark",
					"{C:dark_edition}+#1#{} Joker slots"
				}
			},
			ability_name = "AIZ Blåhaj",
			slug = "aiz_blåhaj",
			ability = {
				extra = {
					j_slots = 1
				}
			},
			rarity = 1,
			cost = 1,
			unlocked = true,
			discovered = true,
			blueprint_compat = false,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(blåhaj, true)

		-- Set local variables
		SMODS.Jokers.j_aiz_blåhaj.loc_def = function(card)
			return { card.ability.extra.j_slots }
		end
	end
	-- if config. then
	-- 	--
	-- 	--

	-- 	-- Create Joker
	-- 	local temp = {
	-- 		loc = {
	-- 			name = "",
	-- 			text = {
	-- 				"",
	-- 			}
	-- 		},
	-- 		ability_name = "AIZ ",
	-- 		slug = "aiz_",
	-- 		ability = {
	-- 			extra = {

	-- 			}
	-- 		},
	-- 		rarity = 1,
	-- 		cost = 4,
	-- 		unlocked = true,
	-- 		discovered = true,
	-- 		blueprint_compat = true,
	-- 		eternal_compat = true,
	-- 	}
	-- 	-- Initialize Joker
	-- 	init_joker(temp, true)

	-- 	-- Set local variables
	-- 	SMODS.Jokers.j_aiz_.loc_def = function(card)
	-- 		return { card.ability.extra }
	-- 	end

	-- 	-- Calculate
	-- 	SMODS.Jokers.j_aiz_.calculate = function(card, context)
	-- 		if SMODS.end_calculate_context(context) then
	-- 			return {
	-- 				message = localize {
	-- 					type = 'variable',
	-- 					key = 'a_xmult',
	-- 					vars = {  }
	-- 				},
	-- 				Xmult_mod = ,
	-- 			}
	-- 		end
	-- 	end
	-- end
end

function SMODS.INIT.JAIZ()
	if config.allEnabled then
		if config.jokersEnabled then Jokers() end
	end


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

		local joker_antibubzia = SMODS.Joker:new("Aiz AntiBubzia", "aiz_antibubzia", { extra = { Xmult = 4 } },
			{ x = 0, y = 0 },
			{
				name = "AntiBubzia",
				text = {
					"Plays the exact",
					"same hand backwards",
					"to cancel out",
					"your score every time",
				}
			}, 1, 4)
		joker_antibubzia:register()
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

local back_trigger_effectref = Back.trigger_effect
function Back:trigger_effect(args)
	back_trigger_effectref(self, args)
	if args.context == 'final_scoring_step' then
		for i = 1, #G.jokers.cards do
			local card = G.jokers.cards[i]
			if card.ability.name == "Aiz AntiBubzia" then
				if card.edition and card.edition.negative then
					args.mult = args.mult * args.mult
				else
					args.mult = 0
					args.chips = 0
				end
				update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })
				delay(0.5)
			end
		end
	end
	return args.chips, args.mult
end

----------------------------------------------
------------MOD CODE END----------------------
