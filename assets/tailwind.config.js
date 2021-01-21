module.exports = {
  future: {
    // removeDeprecatedGapUtilities: true,
    // purgeLayersByDefault: true,
    // defaultLineHeights: true,
    // standardFontWeights: true
  },
  purge: [
    './src/**/*.eex',
    './src/**/*.leex',
  ],
  theme: {
    extend: {
//      fontFamily: {
//        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
//      },
      colors: {
        'gigas': {
          default: '#43399D',
          '100': '#C0BCE7',
          '200': '#9D96D9',
          '300': '#7A71CC',
          '400': '#574BBE',
          '500': '#43399D',
          '600': '#332B78',
          '700': '#231E52',
          '800': '#13102D',
          '900': '#030307'
        },
        'malibu': {
          default: '#8EA2FB',
          '100': '#FFFFFF',
          '200': '#FFFFFF',
          '300': '#F0F3FE',
          '400': '#BFCAFD',
          '500': '#8EA2FB',
          '600': '#5D79F9',
          '700': '#2B51F7',
          '800': '#0831E7',
          '900': '#0727B6'
        },
        primary: {
          default: '#3E3EBB',
          '100': '#D5D5F1',
          '200': '#AFAFE4',
          '300': '#8888D7',
          '400': '#6262CB',
          '500': '#3E3EBB',
          '600': '#323295',
          '700': '#25256F',
          '800': '#181849',
          '900': '#0B0B22'
        },
        secondary: {
          default: '#878582',
          '100': '#EBEBEA',
          '200': '#D2D1D0',
          '300': '#B9B8B6',
          '400': '#A09F9C',
          '500': '#878582',
          '600': '#6D6C69',
          '700': '#535250',
          '800': '#393837',
          '900': '#1F1F1E'
        },
        accent: {
          default: '#DFEF4D',
          '100': '#FFFFFF',
          '200': '#F8FCD9',
          '300': '#F0F8AB',
          '400': '#E8F47C',
          '500': '#DFEF4D',
          '600': '#D7EB1E',
          '700': '#B3C511',
          '800': '#88960D',
          '900': '#5E6709'
        },
      }
    }
  },
  variants: {},
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ]
}
