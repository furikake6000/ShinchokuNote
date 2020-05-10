// ref: https://qiita.com/okabee326/items/014c282a24b0886c814e#webpack%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B

const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
  devtool: 'inline-source-map',
  mode: 'development',
  entry: {
    webpack: './src/entry.js'
  },
  output: {
    path: '/ShinchokuNote/app/assets/javascripts',
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.css$/,
        use: ['vue-style-loader', 'css-loader']
      },
      {
        test: /\.s(a|c)ss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          {
            loader: 'sass-loader'
          },
        ]
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.vue'],
    alias: {
      vue$: 'vue/dist/vue.esm.js'
    }
  },
  plugins: [
    new VueLoaderPlugin()
  ]
};
