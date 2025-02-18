// tailwind.config.js

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  safelist: [
    'alert', 
    'alert-success', 
    'alert-error', 
    'alert-info', 
    'alert-warning'
  ],
  plugins: [require("daisyui")],
  daisyui: {
    darkTheme: false, // ダークモードをONにする場合は削除
    themes: [
      {
        mytheme: {
          "primary": "#9AD3E5",
          "info": "#3D5F91",
          "success": "#ffcc7a",
          "warning": "#FACC15",
          "error": "#ff7c7c",
          "neutral": "#D4D4D8",
          "base-100": "#fffdf9",
          "gray-200": "#E5E7EB",
          "gray-300": "#D1D5DB",
          "gray-400": "#9CA3AF",
          "gray-500": "#6B7280"
        },
      },
    ],
  },
}
