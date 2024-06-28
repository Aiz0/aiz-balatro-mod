--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: AIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: A mod adding Jokers I thought would be funny, cool or just felt like making. Has not been balance tested.
--- BADGE_COLOUR: 0ea5e9
--- VERSION: 0.6.0
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

-- Global Table for mod utils and config
Aiz = {}

-- contains filenames of modules that can be enabled disabled
local modules = {
	jokers = {
		"chill_joker",
		"loudspeaker",
		"easy_mode",
		"blåhaj",
		"antibubzia",
		"hand_size",
		"tetris",
		"penny",
		"trollker",
		"chess_pawn",
		"chess_knight",
		"chess_bishop",
		"chess_rook",
		"chess_queen",
		"chess_king",
		"jay_z",
		"chaos",
		"tinkerer",
		"skipper",
		"banana_farm",
		"kiki_bouba",
		"slightly_cooler_joker",
		"ultimate_unknown",
		"ultimate_gamer",
		"skipper_old",
	},
}

function SMODS.current_mod.process_loc_text()
	-- Localization
	G.localization.misc.dictionary.k_aiz_advance = "Advance!"
	G.localization.misc.dictionary.k_aiz_promoted = "Promoted!"
	G.localization.misc.dictionary.k_aiz_trolled = "Trolled!"
	G.localization.misc.dictionary.k_aiz_squared = "Squared!"
	G.localization.misc.dictionary.k_aiz_cancelled = "Cancelled!"
	G.localization.misc.dictionary.k_aiz_knowledge_gained = "Knowledge Gained!"
	G.localization.misc.dictionary.k_aiz_dinner_postponed = "Dinner Postponed!"
	G.localization.misc.dictionary.k_aiz_destroy = "Destroyed!"
	G.localization.misc.dictionary.k_aiz_light = "Light"
	G.localization.misc.dictionary.k_aiz_dark = "Dark"
	G.localization.misc.dictionary.k_aiz_new_hand = "New Hand!"
	G.localization.misc.dictionary.k_aiz_odds_increased = "Odds Increased!"
	G.localization.misc.dictionary.k_aiz_odds_doubled = "Odds Doubled!"
	G.localization.misc.dictionary.k_aiz_kiki = "Kiki!"
	G.localization.misc.dictionary.k_aiz_bouba = "Bouba!"
	G.localization.misc.challenge_names.c_aiz_penny = "In For a Penny..."
end

SMODS.Atlas({
	key = "jokers",
	path = "jokers.png",
	px = 71,
	py = 95,
})
SMODS.Atlas({
	key = "jokers_soul",
	path = "jokers_soul.png",
	px = 71,
	py = 95,
})

local mod_path = SMODS.current_mod.path
-- load config & utils
-- NFS.load is a love2D function
NFS.load(mod_path .. "utils.lua")()
NFS.load(mod_path .. "config.lua")()

-- load all enabled jokers
-- only explicitly disabled jokers are disabled
-- jokers not listed are still enabled
for _, joker in ipairs(modules.jokers) do
	local enabled = Aiz.config.jokers[joker] == nil or Aiz.config.jokers[joker]
	if enabled then
		NFS.load(mod_path .. "jokers/" .. joker .. ".lua")()
	end
end

--Challenge
table.insert(G.CHALLENGES, 1, {
	name = "Doubled",
	id = "c_aiz_penny",
	rules = {
		custom = {},
		modifiers = {},
	},
	jokers = {
		{ id = "j_aiz_penny", eternal = true },
	},
	consumeables = {},
	vouchers = {},
	deck = {
		type = "Challenge Deck",
	},
	restrictions = {
		banned_cards = {},
		banned_tags = {},
		banned_other = {},
	},
})
