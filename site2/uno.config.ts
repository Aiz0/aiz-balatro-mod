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
    colors: colors
  },
});
