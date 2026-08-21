import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // Premium palette: deep charcoal/black base, warm gold accent, off-white
        obsidian: {
          950: "#0a0a0b",
          900: "#121214",
          800: "#1c1c1f",
          700: "#2a2a2e",
        },
        gold: {
          400: "#d4b877",
          500: "#c6a561",
          600: "#a8873e",
        },
        ivory: "#f7f5f2",
      },
      fontFamily: {
        display: ["var(--font-display)"],
        body: ["var(--font-body)"],
      },
      letterSpacing: {
        widest2: "0.2em",
      },
    },
  },
  plugins: [],
};
export default config;
