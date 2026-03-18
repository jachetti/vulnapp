/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'cs-dark': '#17161a',
        'cs-darker': '#000000',
        'cs-red': '#e01f3d',
        'cs-gray': '#888888',
        'cs-white': '#ffffff',
        'cs-success': '#10b981',
        'cs-warning': '#f59e0b',
        'cs-error': '#ef4444',
        'cs-info': '#3b82f6',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'sans-serif'],
        mono: ['JetBrains Mono', 'Consolas', 'Monaco', 'monospace'],
      },
    },
  },
  plugins: [],
}
