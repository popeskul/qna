var path = require("path");

module.exports = {
    test: /\.hbs$/,
    loader: 'handlebars-loader',
    query: {
        partialDirs: [
            path.join(__dirname, '../../javascript/templates')
        ]
    }
}
