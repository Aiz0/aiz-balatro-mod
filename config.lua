Aiz.config = {
	-- jokers not listed here will still be enabled
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
		chess_knight = true,
		chess_pawn = true,
		antibubzia = true,
		hand_size = true,
		chaos = true,
		tinkerer = true,
		gamer = true,
		skipper = true,
		banana_farm = true,
	},

	suits = {
		Light = {
			Hearts = true,
			Diamonds = true,
		},
		Dark = {
			Spades = true,
			Clubs = true,
		},
	},

	-- slug and probability
	pawn = {
		promotion = {
			j_aiz_chess_knight = 10,
			j_aiz_chess_bishop = 7,
			j_aiz_chess_rook = 5,
			j_aiz_chess_queen = 3,
			j_aiz_chess_king = 1,
		},
		-- if you have any of above reduce probability by multiplying with this value
		duplicate_chance_reduction = 0.5,
	},
}
