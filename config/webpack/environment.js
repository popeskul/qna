const path = require("path")
const webpack = require('webpack')
const { environment } = require('@rails/webpacker')

environment.loaders.prepend('handlebars', {
    test: /\.hbs$/,
    loader: 'handlebars-loader',
    query: {
        partialDirs: [
            path.resolve(__dirname, '../../app/javascript/templates')
        ]
    }
})

environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery',
        jquery: 'jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default']
    })
)

module.exports = environment
