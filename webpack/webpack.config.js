module.exports=(ENV={NODE_ENV: 'dev'}) => {
/***** set environment *****/
  let env=ENV.NODE_ENV;
  env=(env==='prod'||env==='production'||env==='dist')?'prod':'dev';

/***** base *****/
const path=require('path');
const webpack=require('webpack');
const merge=require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const UglifyJSWebpackPlugin=require('uglifyjs-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

let base={
  entry: path.join(__dirname,'src/index.js'),
  output: {
    // path: path.resolve(__dirname,'dist'),
    // publicPath: 'http://127.0.0.1:8888/',
    filename: 'bundle-[chunkhash].js',
    chunkFilename: '[name].js',
    // library: 'math',
    // libraryTarget: 'umd',
  },
  module: {
    rules: [
      {
        test: /\.(html|htm)$/,
        use: [
          // {
            // loader: 'file-loader',
            // options: {
              // name: '[name].[ext]',
            // },
          // },
          // {
            // loader: 'extract-loader',
            // options: {
            // },
          // },
          {
            loader: 'html-loader',
            options: {
              // attrs: false,
              attrs: ['img:src','img:data-src','link:href'],
              // root: '/',
            },
          },
        ],
      },
      {
        test: /\.txt$/,
        use: [
          {
            loader: 'raw-loader',
          },
        ],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: './src/index.html',
      favicon:  './src/img/favicon.png',
      meta: {},
      // title: env==='dev'?'development':'production',
      // hash: true,
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      React: 'react',
      ReactDOM: 'react-dom',
    }),
  ],
};

/***** development *****/
let dev=merge(base,{
  mode: 'development',
  output: {
    path: path.resolve(__dirname,'dev'),
  },
  module: {
    rules: [
      {
        test: /\.(jsx)$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader?cacheDirectory=true',
            options: {
              presets: ['env','react'],
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
            options: {
              // modules: true,
              importLoaders: 1,
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
            options: {
              // modules: true,
              importLoaders: 1,
            },
          },
          {
            loader: 'sass-loader',
            options: {
              outputStyle: 'expanded',
              // sourceComments: true,
            },
          },
        ],
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg|bmp|ico)$/,
        use: [
          {
            loader: 'url-loader',
          },
        ],
      },
      {
        test: /\.(woff|woff2|svg|ttf|eot)$/,
        include: /(font|fonts)/,
        use: [
          {
            loader: 'url-loader',
          },
        ],
      },
    ],
  },
  plugins: [
    new CleanWebpackPlugin(['dev/*']),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('development'),
    }),
  ],
  devServer: {
    contentBase: path.resolve(__dirname,'dev'),
  },
  // devtool: 'inline-source-map',
  devtool: 'inline-cheap-module-source-map',
});

/***** production *****/
let prod=merge(base,{
  mode: 'production',
  output: {
    path: path.resolve(__dirname,'dist'),
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx|es)$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader?cacheDirectory=true',
            options: {
              presets: ['env','react'],
            },
          },
        ],
      },
      {
        test: /\.css$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              // modules: true,
              minimize: true,
              importLoaders: 1,
            },
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: (loader) => [
                require('autoprefixer')(),
              ], 
            },
          },
        ],
      },
      {
        test: /\.scss$/,
        use: [
          // {
            // loader: 'file-loader',
            // options: {
              // name: '[name]-[hash].scss.css',
            // },
          // },
          // {
            // loader: 'extract-loader',
          // },
          {
            loader: MiniCssExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              // modules: true,
              minimize: true,
              importLoaders: 2,
            },
          },
          {
            loader: 'postcss-loader',
            options: {
              ident: 'postcss',
              plugins: (loader) => [
                require('autoprefixer')(),
              ], 
            },
          },
          {
            loader: 'sass-loader',
            options: {
              outputStyle: 'compressed',
            },
          },
        ],
      },
      {
        test: /\.(png|jpg|jpeg|gif|svg|bmp|ico)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              // publicPath: 'assets',
              outputPath: 'img',
            },
          },
        ],
      },
      {
        test: /\.(woff|woff2|svg|ttf|eot)$/,
        include: /(font|fonts)/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: 'fonts/[name].[ext]',
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new CleanWebpackPlugin(['dist/*']),
    new UglifyJSWebpackPlugin({
      // test: /\.js$/,
      cache: true,
      parallel: true,
    }),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify('production'),
    }),
    new MiniCssExtractPlugin({
      filename: "bundle-[chunkhash].css",
      chunkFilename: "[name].css",
    }),
  ],
  externals: {
    // jquery: 'window.JQuery',
    // underscore: {
      // commonjs: 'underscore',
      // commonjs2: 'underscore',
      // amd: 'underscore',
      // root: '_',
    // }
  },
  optimization: {
    splitChunks: {
      automaticNameDelimiter: '-',
      cacheGroups: {
        vendor: {
          chunks: 'all',
          minSize: 1,
          test: /node_modules/,
          // name: 'common',
          // priority: -10,
        },
      },
    },
  },
});

/***** exports *****/
return (env==='prod')?prod:dev;
};
