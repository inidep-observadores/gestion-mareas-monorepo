import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./index.html', './src/**/*.{vue,ts}'],
  theme: {
    extend: {
      colors: {
        sigma: {
          blue: '#0078ff',
          cyan: '#00f2ff',
          dark: '#0f1c2e',
        },
      },
    },
  },
  plugins: [],
};

export default config;
