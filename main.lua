--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: AIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: jank jokers
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------
local config = {
	jokers = {
		blåhaj = true,
		loudspeaker = true,
		easy_mode = true,
		chill_joker = true,
		tetris = true,
		penny = true,
		trollker = true,
		jay_z = true,
		chess_bishop = true,
		chess_rook = true,
		chess_queen = true,
		chess_king = true,
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
-- load utils
require(mod_path .. "utils")

-- load all enabled jokers
for joker, enabled in pairs(config.jokers) do
	if enabled then
		require(mod_path .. "jokers/" .. joker)
	end
end
