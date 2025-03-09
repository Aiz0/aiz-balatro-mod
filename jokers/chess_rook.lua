-- Chess rook
-- Turn cards into stone.
-- Discarded cards are turned
-- -1 discard because of this.
SMODS.Joker({
    key = "chess_rook",

    config = {
        extra = {
            discard_size = 1,
            base = 4, -- controls max mult
            exponent = 2, -- controls how fast/slow mult should grow
        },
    },
    atlas = "jokers",
    pos = { y = 1, x = 5 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    pools = {
        ["aiz_chess_promotion_joker"] = true,
        ["Joker"] = false,
    },
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.discard_size,
                self.get_xmult(card),
            },
        }
    end,

    get_xmult = function(card)
        if G.playing_cards == nil then
            return 1
        else
            local stone_tally = 0
            for _, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.m_stone then
                    stone_tally = stone_tally + 1
                end
            end

            return card.ability.extra.base
                ^ (
                    (stone_tally / #G.playing_cards)
                    ^ card.ability.extra.exponent
                )
        end
    end,

    calculate = function(self, card, context)
        if context.pre_discard and not context.blueprint then
            local cards = {}
            for _, playing_card in pairs(G.hand.highlighted) do
                if not (playing_card.config.center == G.P_CENTERS.m_stone) then
                    table.insert(cards, playing_card)
                    Aiz.utils.flip_card_event(playing_card)
                end
            end
            for _, playing_card in pairs(cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.1,
                    func = function()
                        playing_card:set_ability(G.P_CENTERS["m_stone"])
                        return true
                    end,
                }))
            end
            for _, playing_card in pairs(cards) do
                Aiz.utils.flip_card_event(playing_card)
            end
            if #cards > 0 then
                delay(0.3)
            end
        end
        if context.joker_main then
            return { xmult = self.get_xmult(card) }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards
            - card.ability.extra.discard_size
        ease_discard(-card.ability.extra.discard_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards
            + card.ability.extra.discard_size
        ease_discard(card.ability.extra.discard_size)
    end,
})
