--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: AIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers
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
	},
}

function SMODS.current_mod.process_loc_text()
	-- Localization
	-- Don't know if doing this is allowed.
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
end

SMODS.Atlas({
	key = "jokers",
	path = "jokers.png",
	px = 71,
	py = 95,
})

local mod_path = SMODS.current_mod.path
-- load config & utils
require(mod_path .. "utils")
require(mod_path .. "config")

-- load all enabled jokers
-- only explicitly disabled jokers are disabled
-- jokers not listed are still enabled
for _, joker in ipairs(modules.jokers) do
	local enabled = Aiz.config.jokers[joker] == nil or Aiz.config.jokers[joker]
	if enabled then
		require(mod_path .. "jokers/" .. joker)
	end
end
