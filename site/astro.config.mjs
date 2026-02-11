import { defineConfig } from "astro/config";
import UnoCSS from "unocss/astro";

export default defineConfig({
  integrations: [UnoCSS()],
  site: "https://balatro.aiz.moe"
});
