-- Global table for mod utils
Aiz = {}
local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path

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
        "randomizer",
        "tinkerer",
        "skipper",
        "banana_farm",
        "kiki_bouba",
        "slightly_cooler_joker",
        "ultimate_unknown",
        "ultimate_gamer",
        "battle_pass",
        "chess_pawn_storm",
        --"schmeven",
        "factory_triangle_maker",
        "factory_triangle",
        "factory_circle",
    },
}

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

SMODS.ObjectType({
    key = "aiz_chess_promotion_joker",
    rarities = {
        { key = "Uncommon", rate = 0.7 },
        { key = "Rare", rate = 0.2 },
        { key = "Legendary", rate = 0.1 },
    },
})

-- load utils
assert(SMODS.load_file("utils.lua"))()
assert(SMODS.load_file("configuration.lua"))()

-- load all enabled jokers
-- only explicitly disabled jokers are disabled
-- jokers not listed are still enabled
for _, joker in ipairs(modules.jokers) do
    local enabled = Aiz.config.jokers[joker] == nil or Aiz.config.jokers[joker]
    if enabled then
        assert(SMODS.load_file("jokers/" .. joker .. ".lua"))()
    end
end

-- Challenge
-- Since its only one right now i keep it here
SMODS.Challenge({
    key = "aiz_penny",
    jokers = {
        { id = "j_aiz_penny", eternal = true },
    },
})
