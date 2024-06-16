/** @type {import('tailwindcss').Config} */
const colors = require("tailwindcss/colors");
const plugin = require("tailwindcss/plugin");
const {
  default: flattenColorPalette,
} = require("tailwindcss/lib/util/flattenColorPalette");
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        balatro: ["m6x11plus"],
      },
      colors: {
        balatro: {
          white: "#ffffff", // edition
          red: {
            DEFAULT: "#fe5f55", // mult, xmult, rare
            dark: "#ca0d01",
          },
          blue: {
            DEFAULT: "#009dff", // chips, uncommon
            dark: "#005e99",
            special: "#5d5dff", // spectral, dark edition, boss blind, seal
          },
          gold: {
            DEFAULT: "#f3b958", // money
            dark: "#eac058", // gold
          },
          yellow: "#ffff00",
          orange: {
            DEFAULT: "#ff9a00", // attention, important,
            other: "#fda200",
            voucher: "#fd682b", // voucher
          },
          green: {
            pale: "#56a887",
            DEFAULT: "#4bc292", // chance, uncommmon
            dark: "#297958",
            edition: "#4ca893",
          },

          purple: {
            tarot: "#a782d1",
            DEFAULT: "#b26cbb", // legendary
            dark: "#723879",
            other: "#8867a5", // purple
            booster: "#646eb7",
            showdown: "#4584fa",
          },
          black: {
            DEFAULT: "#374244",
            light: "#4f6367", // l_black
          },
          grey: {
            DEFAULT: "#d8d8d8", // outline
            dark: "#828282", // outline
            light: "#88888899", // inactive
            other: "#5f7377",
            joker: "#bfc7d5", // joker_gray
            enhancement: "#8389dd",
          },
          cyan: {
            DEFAULT: "#13afce", //planet
          },
          brown: "#cb724c", // voucher thingy

          // Gonna Keep these as is
          hearts: "#f03464",
          diamonds: "#f06b3f",
          spades: "#403995",
          clubs: "#235955",
          eternal: "#c75985",
          deck: "#9bb6bd", // pack aswell
          joker: "#708b91",
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
  plugins: [
    plugin(function ({ matchUtilities, theme }) {
      matchUtilities(
        {
          "custom-shadow": (value) => ({
            filter: `drop-shadow(0 0.25rem 0${value})`,
          }),
        },
        {
          values: flattenColorPalette(theme("colors")),
          type: "color",
        },
      );
    }),
  ],
};
