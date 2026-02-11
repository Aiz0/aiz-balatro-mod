import { defineConfig, presetWind4 } from "unocss";
import { colors } from "./src/theme";

export default defineConfig({
  presets: [
    presetWind4({
      preflights: {
        reset: true,
      },
    }),
  ],
  theme: {
    font: {
      sans: "m6x11plus",
    },
    colors: colors,
  },
  shortcuts: {
    "balatro-shadow": "drop-shadow-[0_0.5rem_0] drop-shadow-color-black/20",
  },
});
