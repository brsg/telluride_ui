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
      colors: {
        producer: '#010e72',
        processor: '#2239ab',
        batcher: '#3c70cf',
        batchprocessor: '#6d6d6d',
        normal: '#00ff00',
        warning: '#ffff00',
        error: '#ff0000'
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
