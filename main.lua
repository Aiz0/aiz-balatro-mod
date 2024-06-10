--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: AIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

-- contains filenames of modules that can be enabled disabled
local modules = {
	jokers = {
		"blåhaj",
		"loudspeaker",
		"easy_mode",
		"chill_joker",
		"tetris",
		"penny",
		"trollker",
		"jay_z",
		"chess_bishop",
		"chess_rook",
		"chess_queen",
		"chess_king",
		"chess_knight",
		"chess_pawn",
		"antibubzia",
		"hand_size",
		"chaos",
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
	local enabled = Aiz_config.jokers[joker] == nil or Aiz_config.jokers[joker]
	if enabled then
		require(mod_path .. "jokers/" .. joker)
	end
end
