const jokers = [
  {
    name: "Chill Joker",
    text: ["{X:mult,C:white}X2{} Mult divided", "by game speed"],
    badge: "Rare",
    image: "j_chill_joker",
  },
  {
    name: "Loudspeaker",
    text: ["Gives {C:chips}Chips{} based", "on {C:attention}Audio volume{}"],
    badge: "common",
    image: "j_loudspeaker",
  },
  {
    name: "Easy Mode",
    text: [
      "Gives {C:mult}+1 mult{} for",
      "every 2 jokers with",
      "{C:attention}White stickers{}",
      "in your collection",
    ],
    badge: "uncommon",
    image: "j_easy_mode",
  },
  {
    name: "Blåhaj",
    text: ["{C:dark_edition}+1{} Joker slots"],
    badge: "common",
    image: "j_s_blåhaj",
    soul: true,
  },
  {
    name: "AntiBubzia",
    text: [
      "Plays the exact",
      "same hand backwards",
      "to cancel out",
      "your score",
      "every {C:attention}freaking{} time",
    ],
    badge: "rare",
    image: "j_antibubzia",
  },
  {
    name: "Too Much To Handle",
    text: [
      "When blind is selected",
      "set a random hand size",
      "between {C:attention}4{} and {C:attention}15",
    ],
    badge: "rare",
    image: "j_hands",
  },
  {
    name: "Tetris",
    text: [
      "This Joker Gains {X:mult,C:white}X0.5{} Mult",
      "per {C:attention}consecutive{} hand",
      "played without",
      "repeating a {C:attention}poker hand{}",
    ],
    badge: "Rare",
    image: "j_tetris",
  },
  {
    name: "Penny",
    text: [
      "At end of round,",
      "duplicate {C:attention}All{} cards",
      "in your deck",
    ],
    badge: "rare",
    image: "j_penny",
  },
  {
    name: "Trollker",
    text: [
      "This Joker gains {X:mult,C:white}X1",
      "Mult at end of round.",
      "This joker may do",
      "a little bit of {C:attention,E:1,S:1.1}Trolling",
    ],
    badge: "Rare",
    image: "j_trollker",
  },
  {
    name: "Pawn",
    text: [
      "Advances at end of round",
      "or when skipping a {C:attention}Blind",
      "Adds current rank to mult",
      "{C:inactive}(Currently on rank {C:attention}2{C:inactive})",
    ],
    badge: "common",
    image: "j_pawn",
  },
  {
    name: "Knight",
    text: [
      "Converts scored {C:attention}Dark{} suits",
      "To random {C:attention}Light{} suits",
      "Give {C:mult}+10{} Mult for each",
      "converted card in played hand",
      "{s:0.8}Flips order after conversion{}",
    ],
    badge: "uncommon",
    image: "j_knight",
  },
  {
    name: "Bishop",
    text: [
      "Scored Numbered cards",
      "earn {C:money}$1{}",
      "Scored Face cards",
      "{C:attention}lose{} {C:money}$1",
    ],
    badge: "uncommon",
    image: "j_bishop",
  },
  {
    name: "Rook",
    text: [
      "Enhances {C:attention}Discarded{} cards",
      "into {C:attention}Stone Cards{}",
      "{C:attention}-1{} discards",
      "Gives {X:mult,C:white}XMult{} based on ratio of",
      "{C:attention}Stone cards{} in your {C:attention}full deck.",
    ],
    badge: "rare",
    image: "j_rook",
  },
  {
    name: "Queen",
    text: [
      "When blind is selected,",
      "destroy all cards",
      "of {C:attention}lowest{} rank",
      "in your full deck.",
      "This Joker gains {X:mult,C:white}X0.1{} Mult",
      "for each card destroyed",
    ],
    badge: "rare",
    image: "j_queen",
  },
  {
    name: "King",
    text: ["Other {C:attention}Chess Jokers", "Give {X:mult,C:white}X5{} Mult"],
    badge: "legendary",
    image: "j_s_king",
    soul: true,
  },
  {
    name: "Jay-Z",
    text: [
      "{C:green}1 in 10{} chance this",
      "card is destroyed and",
      "{C:dark_edition}Polychrome{} is added",
      "to {C:attention}All{} cards",
      "at end of round",
    ],
    badge: "legendary",
    image: "j_s_jay_z",
    soul: true,
  },
  {
    name: "Randomizer",
    text: [
      "Cards are scored",
      "in a {C:green,E:2}random{} order",
      "Played cards give",
      "{C:chips}+20{} chips",
      "when scored",
    ],
    badge: "common",
    image: "j_randomizer",
  },
  {
    name: "Tinkerer",
    text: [
      "{X:mult,C:white}X0.1{} Mult for each",
      "{C:attention}Mod{} you have {C:attention}Active{}",
    ],
    badge: "uncommon",
    image: "j_tinkerer",
  },
  {
    name: "Skipper",
    text: [
      "Gain {X:mult,C:white}X1{} when",
      "{C:attention}Boss Blind{} is defeated",
      "Lose {X:mult,C:white}X0.75{} when",
      "{C:attention}Small Blind{} or {C:attention}Big Blind{}",
      "is defeated",
    ],
    badge: "uncommon",
    image: "j_skipper",
  },
  {
    name: "Banana Farm",
    text: ["New {C:attention}Jokers{} appear as", "{C:attention}Gros Michel{}"],
    badge: "uncommon",
    image: "j_banana_farm",
  },
  {
    name: "Kiki/Bouba",
    text: [
      "{C:attention}Kiki{} Jokers",
      "each give {C:mult}+6{} Mult",
      "{C:attention}Bouba{} Jokers",
      "each give {C:chips}+30{} Chips",
    ],
    badge: "common",
    image: "j_kiki_bouba",
  },
  {
    name: "Slightly Cooler Joker",
    text: ["{C:mult}+5{} Mult"],
    badge: "common",
    image: "j_slightly_cooler_joker",
  },
  {
    name: "Ultimate ???",
    text: [
      "Upgrade the level of",
      "up to {C:attention}3{} of your",
      "{C:attention}least played{} poker hands",
      "when skipping a {C:attention}Blind",
    ],
    badge: "uncommon",
    image: "j_s_ultimate_unknown",
    soul: true,
  },
  {
    name: "Ultimate Gamer",
    text: [
      "{C:chips}+10{} Chips for each",
      "{C:attention}Challenge{} you have",
      "{C:attention}Completed{}",
    ],
    badge: "uncommon",
    image: "j_s_ultimate_gamer",
    soul: true,
  },
  {
    name: "Battle Pass",
    text: [
      "{C:attention}+2{} levels when a",
      "poker hand is upgraded",
      "Does not apply to",
      "{C:attention}Planet cards",
    ],
    badge: "common",
    image: "j_battle_pass",
  },
  {
    name: "Pawn Storm",
    text: [
      "When blind is selected,",
      "if you have no Pawns",
      "create {C:attention}2 Pawns",
      "{C:inactive}(Must have room){}",
    ],
    badge: "uncommon",
    image: "j_pawn_storm",
  },
];
export { jokers };
