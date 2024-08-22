--- STEAMODDED HEADER
--- MOD_NAME: Aiz Jokers
--- MOD_ID: AIZ
--- MOD_AUTHOR: [Aiz]
--- MOD_DESCRIPTION: A mod adding Jokers I thought would be funny, cool or just felt like making.
--- BADGE_COLOUR: 0ea5e9
--- VERSION: 0.8.2
--- LOADER_VERSION_GEQ: 1.0.0-ALPHA-0731b-STEAMODDED

----------------------------------------------
------------MOD CODE -------------------------
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
        "schmeven",
        "factory_triangle_maker",
        "factory_triangle",
        "factory_circle",
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

-- Booster packs

SMODS.Atlas({
    key = "booster",
    path = "booster.png",
    px = 71,
    py = 95,
})
SMODS.Booster({
    loc_txt = {
        name = "Joker Pack",
        text = {
            "Choose {C:attention}1{} of up to",
            "{C:attention}3{} {C:dark_edition}Aiz{} Joker Cards",
        },
    },
    key = "joker_pack",
    atlas = "booster",
    pos = { x = 0, y = 0 },
    group_name = "jokerpacks",
    weight = 4,
    cost = 6,
    config = { extra = 3, choose = 1, name = "Common Buffoon Pack" },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.config.center.config.choose, card.ability.extra },
        }
    end,
    create_card = function(self, card)
        -- these numbers are made up
        local weighted_table = {
            chill_joker = 4,
            loudspeaker = 4,
            easy_mode = 4,
            blåhaj = 5,
            antibubzia = 3,
            hand_size = 4,
            tetris = 4,
            penny = 4,
            trollker = 4,
            chess_pawn = 6,
            chess_knight = 1,
            chess_bishop = 1,
            chess_rook = 1,
            chess_queen = 1,
            chess_king = 1,
            jay_z = 2,
            randomizer = 5,
            tinkerer = 4,
            skipper = 6,
            banana_farm = 6,
            kiki_bouba = 6,
            slightly_cooler_joker = 6,
            ultimate_unknown = 4,
            ultimate_gamer = 4,
            battle_pass = 4,
            chess_pawn_storm = 4,
            schmeven = 5,
            factory_triangle_maker = 5,
            factory_triangle = 1,
            factory_circle = 1,
        }
        local joker =
            Aiz.utils.get_weighted_random(weighted_table, "aiz_jokers")
        return SMODS.create_card({
            key = "j_" .. current_mod.prefix .. "_" .. joker,
        })
    end,
})
