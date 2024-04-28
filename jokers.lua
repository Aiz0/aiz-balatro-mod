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
	chess_pawn = true,
	chess_knight = true,
	chess_bishop = true,
	chess_rook = true,
	chess_queen = true,
	chess_king = true,
}

-- Helper functions
-- Some are Copied from Mikas Mod Collection
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
			SMODS.findModByID("JAIZ").path,
			new_joker.slug .. ".png",
			71,
			95,
			"asset_atli"
		)
		sprite:register()
	end
end


local suits = {
	light = {
		"Hearts",
		"Diamonds"
	},
	dark = {
		"Spades",
		"Clubs",
	}
}
local function get_suit_type(card)
	for i, suit in ipairs(suits.dark) do
		if card.base.suit == suit then
			return "Dark"
		end
	end
	for i, suit in ipairs(suits.light) do
		if card.base.suit == suit then
			return "Light"
		end
	end
	return "Unknown"
end

local function get_random_suit_of_type(light_suit)
	return pseudorandom_element(((light_suit) and suits.light or suits.dark), pseudoseed("random_suit"))
end

local function is_chess_joker(ability_name)
	local chess_jokers = {
		"Aiz Pawn",
		"Aiz Knight",
		"Aiz Bishop",
		"Aiz Rook",
		"Aiz Queen",
		"Aiz King",
	}

	for index, chess_ability in ipairs(chess_jokers) do
		if chess_ability == ability_name then
			return true
		end
	end
	return false
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
			ability_name = "Aiz Chill Joker",
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
			ability_name = "Aiz Loudspeaker",
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
			ability_name = "Aiz Easy Mode",
			slug = "aiz_easy_mode",
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
			ability_name = "Aiz Blåhaj",
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

	if config.antiBubzia then
		-- AntiBubzia
		-- Sets chips and mult to 0
		-- if negative, squares chips and mult
		-- Has code in Back:trigger_effect

		-- Create Joker
		local antibubzia = {
			loc = {
				name = "AntiBubzia",
				text = {
					"Plays the exact",
					"same hand backwards",
					"to cancel out",
					"your score every time",
				}
			},
			ability_name = "Aiz AntiBubzia",
			slug = "aiz_antibubzia",
			ability = {
				extra = {

				}
			},
			rarity = 3,
			cost = 10,
			unlocked = true,
			discovered = true,
			blueprint_compat = false,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(antibubzia, true)

		-- Set local variables
		SMODS.Jokers.j_aiz_antibubzia.loc_def = function(card)
			return {}
		end
	end
	if config.backwardsLongJump then
		-- Backwards Long Jump (BLJ)
		-- Gain mult on trigger reset after scored
		-- TODO implement the code for this. seems kinda hard

		-- Create Joker
		local blj = {
			loc = {
				name = "BLJ",
				text = {
					"This Joker gains {X:mult,C:white}X#2#{} Mult if",
					"a card is triggered during scoring",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
				}
			},
			ability_name = "Aiz Backwards Long Jump",
			slug = "aiz_blj",
			ability = {
				extra = {
					Xmult = 1,
					Xmult_mod = 0.1,
				}
			},
			rarity = 4,
			cost = 15,
			unlocked = true,
			discovered = true,
			blueprint_compat = false,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(blj, true)

		-- Set local variables
		SMODS.Jokers.j_aiz_blj.loc_def = function(card)
			return { card.ability.extra.Xmult_mod, card.ability.extra.Xmult }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_blj.calculate = function(card, context)
			if SMODS.end_calculate_context(context) and card.ability.extra > 1 then
				return {
					message = localize {
						type = 'variable',
						key = 'a_xmult',
						vars = { card.ability.extra.Xmult }
					},
					Xmult_mod = card.ability.extra.Xmult,
				}
			end
		end
	end
	if config.chess_pawn then
		-- Chess pawn
		-- After a few rounds it promotes to a different chess joker

		-- Create Joker
		local pawn = {
			loc = {
				name = "Pawn",
				text = {
					"Advances at end of round",
					"Adds current rank to mult",
					"{C:inactive}(Currently on rank {C:attention}#1#{C:inactive})"
				}
			},
			ability_name = "Aiz Pawn",
			slug = "aiz_pawn",
			ability = {
				extra = {
					rank = 2,
					promotion_rank = 4,
				}
			},
			rarity = 1,
			cost = 5,
			unlocked = true,
			discovered = true,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(pawn)

		-- Set local variables
		SMODS.Jokers.j_aiz_pawn.loc_def = function(card)
			return { card.ability.extra.rank, }
		end


		local function get_random_chess_joker()
			local jokers = {
				j_aiz_knight = { probability = 30 / 100 },
				j_aiz_bishop = { probability = 25 / 100 },
				j_aiz_rook = { probability = 20 / 100 },
				j_aiz_queen = { probability = 15 / 100 },
				j_aiz_king = { probability = 10 / 100 },
			}
			local p = pseudorandom("chess_joker")
			local cumulativeProbability = 0
			for slug, joker in pairs(jokers) do
				cumulativeProbability = cumulativeProbability + joker.probability
				if p <= cumulativeProbability then
					return slug
				end
			end
		end

		-- Calculate
		SMODS.Jokers.j_aiz_pawn.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					message = localize {
						type = 'variable',
						key = 'a_mult',
						vars = { card.ability.extra.rank }
					},
					mult_mod = card.ability.extra.rank,
				}
			end
			-- should increment rank and show appropate message
			if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
				-- This should simulate advancing 2 ranks on first move
				local advances = (card.ability.extra.rank == 2) and 2 or 1
				card.ability.extra.rank = card.ability.extra.rank + advances
				if card.ability.extra.rank == card.ability.extra.promotion_rank then
					-- shows that card is active by shaking it
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize("k_aiz_promoted")
					})
					local joker_slug = get_random_chess_joker()
					local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, joker_slug, nil)
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.3,
								blockable = false,
								func = function()
									G.jokers:remove_card(card)
									card:remove()
									card = nil
									return true;
								end
							}))
							return true
						end
					}))
				else
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = localize("k_aiz_advance")
					})
				end
			end
		end
	end
	if config.chess_knight then
		-- Chess knight
		-- should gives some kind of bonus based on dark/light suits.
		-- switches dark/light every round

		-- Create Joker
		local knight = {
			loc = {
				name = "Knight",
				text = {
					"{C:mult}+#1#{} Mult",

				}
			},
			ability_name = "Aiz Knight",
			slug = "aiz_knight",
			ability = {
				extra = {
					mult = 10,
					change_to_light_suit = true,
				}
			},
			rarity = 2,
			cost = 6,
			unlocked = true,
			discovered = false,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(knight)

		-- remove from pool
		SMODS.Jokers.j_aiz_knight.yes_pool_flag = 'this_flag_will_never_be_set'

		-- Set local variables
		SMODS.Jokers.j_aiz_knight.loc_def = function(card)
			return { card.ability.extra.mult, }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_knight.calculate = function(card, context)
			if context.individual and context.cardarea == G.play then
				if get_suit_type(context.other_card) == ((card.ability.extra.change_to_light_suit) and "Dark" or "Light") then
					local suit = get_random_suit_of_type(card.ability.extra.change_to_light_suit)
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.5,
						func = (function()
							context.other_card:flip()
							play_sound('card1')
							context.other_card:juice_up(0.3, 0.3)
							return true
						end)
					}))
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.5,
						func = function()
							context.other_card:change_suit(suit)
							return true
						end
					}))
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.5,
						func = (function()
							context.other_card:flip()
							play_sound('card1')
							context.other_card:juice_up(0.3, 0.3)
							return true
						end)
					}))
					return {
						card = card,
						mult = card.ability.extra.mult,
					}
				end
			end
			-- flip suit to chaneg at end of round
			if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
				card.ability.extra.change_to_light_suit = not card.ability.extra.change_to_light_suit
			end
		end
	end
	if config.chess_bishop then
		-- Chess bishop
		-- don't know effect yet

		-- Create Joker
		local bishop = {
			loc = {
				name = "Bishop",
				text = {
					"Scored Numbered cards",
					"earn {C:money}$#1#{}",
					"Scored Face cards",
					"{C:attention}lose{} {C:money}$#1#{}",

				}
			},
			ability_name = "Aiz Bishop",
			slug = "aiz_bishop",
			ability = {
				extra = {
					money = 1,
				}
			},
			rarity = 2,
			cost = 6,
			unlocked = true,
			discovered = false,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(bishop)

		-- Set local variables
		SMODS.Jokers.j_aiz_bishop.loc_def = function(card)
			return { card.ability.extra.money, }
		end

		-- remove from pool
		SMODS.Jokers.j_aiz_bishop.yes_pool_flag = 'this_flag_will_never_be_set'

		-- Calculate
		SMODS.Jokers.j_aiz_bishop.calculate = function(card, context)
			if context.individual and context.cardarea == G.play then
				if context.other_card:is_face() then
					G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) - card.ability.extra.money
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.GAME.dollar_buffer = 0; return true
						end)
					}))
					return {
						dollars = card.ability.extra.money * -1,
						card = card
					}
				elseif context.other_card:get_id() >= 2 then
					G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.GAME.dollar_buffer = 0; return true
						end)
					}))
					return {
						dollars = card.ability.extra.money,
						card = card
					}
				end
			end
		end
	end
	if config.chess_rook then
		-- Chess rook
		-- don't know effect yet
		-- maybe something with straights

		-- Create Joker
		local rook = {
			loc = {
				name = "Rook",
				text = {
					"{C:mult}+#1#{} Mult",

				}
			},
			ability_name = "Aiz Rook",
			slug = "aiz_rook",
			ability = {
				extra = {
					mult = 20,
				}
			},
			rarity = 3,
			cost = 8,
			unlocked = true,
			discovered = false,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(rook)

		-- Set local variables
		SMODS.Jokers.j_aiz_rook.loc_def = function(card)
			return { card.ability.extra.mult, }
		end

		-- remove from pool
		SMODS.Jokers.j_aiz_rook.yes_pool_flag = 'this_flag_will_never_be_set'

		-- Calculate
		SMODS.Jokers.j_aiz_rook.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					message = localize {
						type = 'variable',
						key = 'a_mult',
						vars = { card.ability.extra.mult }
					},
					mult_mod = card.ability.extra.mult,
				}
			end
		end
	end
	if config.chess_queen then
		-- Chess queen
		-- don't know effect yet
		-- probably something with queens or face cards.

		-- Create Joker
		local queen = {
			loc = {
				name = "Queen",
				text = {
					"{C:mult}+#1#{} Mult",

				}
			},
			ability_name = "Aiz Queen",
			slug = "aiz_queen",
			ability = {
				extra = {
					mult = 20,
				}
			},
			rarity = 3,
			cost = 15,
			unlocked = true,
			discovered = false,
			blueprint_compat = true,
			eternal_compat = true,
		}
		-- Initialize Joker
		init_joker(queen)

		-- Set local variables
		SMODS.Jokers.j_aiz_queen.loc_def = function(card)
			return { card.ability.extra.mult, }
		end

		-- remove from pool
		SMODS.Jokers.j_aiz_queen.yes_pool_flag = 'this_flag_will_never_be_set'

		-- Calculate
		SMODS.Jokers.j_aiz_queen.calculate = function(card, context)
			if SMODS.end_calculate_context(context) then
				return {
					message = localize {
						type = 'variable',
						key = 'a_mult',
						vars = { card.ability.extra.mult }
					},
					mult_mod = card.ability.extra.mult,
				}
			end
		end
	end
	if config.chess_king then
		-- Chess king
		-- don't know effect yet
		-- will make you lose if destroyed,
		-- bonus based on amount of chess jokers.

		-- Create Joker
		local king = {
			loc = {
				name = "King",
				text = {
					"Other {C:attention}Chess Jokers",
					"Give {X:mult,C:white}X#1#{} Mult",

				}
			},
			ability_name = "Aiz King",
			slug = "aiz_king",
			ability = {
				extra = {
					Xmult = 5,
				},

			},
			rarity = 4,
			cost = 15,
			unlocked = true,
			discovered = false,
			blueprint_compat = true,
			eternal_compat = true,
			soul_pos = { x = 1, y = 0 }
		}
		-- Initialize Joker
		init_joker(king)

		-- remove from pool
		SMODS.Jokers.j_aiz_king.yes_pool_flag = 'this_flag_will_never_be_set'

		-- Set local variables
		SMODS.Jokers.j_aiz_king.loc_def = function(card)
			return { card.ability.extra.Xmult, }
		end

		-- Calculate
		SMODS.Jokers.j_aiz_king.calculate = function(card, context)
			if context.other_joker and context.other_joker.ability.set == 'Joker' and context.other_joker ~= card then
				if is_chess_joker(context.other_joker.ability.name) then
					return {
						message = localize {
							type = 'variable',
							key = 'a_xmult',
							vars = { card.ability.extra.Xmult }
						},
						Xmult_mod = card.ability.extra.Xmult,
					}
				end
			end
		end
	end
end

function SMODS.INIT.JAIZ()
	-- Localization
	G.localization.misc.dictionary.k_aiz_advance = "Advance!"
	G.localization.misc.dictionary.k_aiz_promoted = "Promoted!"


	if config.allEnabled then
		if config.jokersEnabled then Jokers() end
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

-- Handle Deck trigger effect
-- Used for final scoring step with some jokers
local back_trigger_effectref = Back.trigger_effect
function Back:trigger_effect(args)
	back_trigger_effectref(self, args)
	if args.context == 'final_scoring_step' then
		for i = 1, #G.jokers.cards do
			local card = G.jokers.cards[i]
			if card.ability.name == "Aiz AntiBubzia" then
				if card.edition and card.edition.negative then
					args.mult = args.mult * args.mult
					args.chips = args.chips * args.chips
				else
					args.mult = 0
					args.chips = 0
				end
				update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })
				--TODO ADD COOL EFFECT HERE
				delay(0.5)
			end
		end
	end
	return args.chips, args.mult
end

----------------------------------------------
------------MOD CODE END----------------------
