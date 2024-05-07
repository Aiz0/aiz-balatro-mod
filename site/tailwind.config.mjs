/** @type {import('tailwindcss').Config} */
const colors = require("tailwindcss/colors");
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        balatro: ["m6x11plus"],
      },
      colors: {
        balatro: {
          mult: "#fe5f55",
          chips: "#009dff",
          money: "#f3b958",
          xmult: "#fe5f55",
          filter: "#ff9a00",
          attention: "#ff9a00",
          blue: "#009dff",
          red: "#fe5f55",
          green: "#4bc292",
          pale_green: "#56a887",
          orange: "#fda200",
          important: "#ff9a00",
          gold: "#eac058",
          yellow: "#ffff00",
          clear: "#00000000",
          white: "#ffffff",
          purple: "#8867a5",
          black: "#374244",
          l_black: "#4f6367",
          grey: "#5f7377",
          chance: "#4bc292",
          joker_grey: "#bfc7d5",
          voucher: "#cb724c",
          booster: "#646eb7",
          edition: "#ffffff",
          dark_edition: "#5d5dff",
          eternal: "#c75985",
          inactive: "#ffffff99",
          hearts: "#f03464",
          diamonds: "#f06b3f",
          spades: "#403995",
          clubs: "#235955",
          enhanced: "#8389dd",
          joker: "#708b91",
          tarot: "#a782d1",
          planet: "#13afce",
          spectral: "#4584fa",
          badge: {
            common: "#009dff",
            uncommon: "#4bc292",
            rare: "#fe5f55",
            legendary: "#b26cbb",
            joker: "#708b91",
            tarot: "#a782d1",
            planet: "#13afce",
            spectral: "#4584fa",
            voucher: "#fd682b",
            pack: "#9bb6bd",
            enhancement: "#8389dd",
            edition: "#4ca893",
            seal: "#4584fa",
            deck: "#9bb6bd",
            sticker: "#5d5dff",
            boss_blind: "#5d5dff",
            showdown: "#4584fa",
          },
        },
      },
      dropShadow: {
        soul: "0 0.5rem rgba(0,0,0,0.25)",
      },
      keyframes: {
        soul: {
          "0%, 100%": { transform: "rotate(-5deg) scale(1)" },
          "50%": { transform: "rotate(5deg) scale(1.05)" },
        },
      },
      animation: {
        soul: "soul 7s ease-in-out infinite",
      },
    },
  },
  safelist: [{ pattern: /bg-balatro-/ }, { pattern: /text-balatro-/ }],
  plugins: [],
};
