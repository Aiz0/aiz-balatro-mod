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
	},
}

SMODS.Atlas({
	key = "jokers",
	path = "jokers.png",
	px = 71,
	py = 95,
})
local mod_path = SMODS.current_mod.path
for joker, enabled in pairs(config.jokers) do
	if enabled then
		require(mod_path .. "jokers/" .. joker)
	end
end
