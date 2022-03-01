const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
      "org/**/*.org",
      "public/**/*.html"
  ],
  darkMode: "class",
  theme: {
     gridTemplateAreas: {
      mobile: ['header header header', 'main main main', 'footer footer footer'],
      desktop: ['sidebar header header', 'sidebar main main', 'sidebar main main'],
    }, 
    extend: {
        gridTemplateColumns: {
        layout: '0.7fr 2.3fr 1fr',
      },
      gridTemplateRows: {
        layout: '0.2fr 2.6fr 0.2fr',
      },
      height: {
        '13': '52px',
        '18': '66px'
      },
       screens: {
        mobile: { max: '1023px'}
       },
        fontFamily: {
            alegreya: ["Alegreya", defaultTheme.fontFamily.serif],
        },
        colors: {
            heraldic: {
                red: "#bc2e2e",
                blue: "#0d6793",
            },
        },
        typography: (theme) => ({
            DEFAULT: {
              css: {
                  fontFamily: defaultTheme.fontFamily.serif,
                  
                  "h1,h2,h3,h4,h5,h6": {
                      fontFamily: [theme("fontFamily.alegreya")],
                  },
              },
            },
            manuscript: {
                css: {
                    "--tw-prose-links": theme("colors.heraldic.blue"),
                    // ...
                },
            },
        }), 
    },
  },
  plugins: [
      require("@tailwindcss/typography"),
      require("@savvywombat/tailwindcss-grid-areas"),
      require("tailwind-scrollbar")
  ],
}
