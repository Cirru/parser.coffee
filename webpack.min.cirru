
var
  webpack $ require :webpack
  config $ require :./webpack.config
  fs $ require :fs

= module.exports $ object
  :entry $ object
    :main $ array :./src/main
    :vendor $ array

  :output $ object
    :path :build/
    :filename :[name].[chunkhash:8].js
    :publicPath :./build/

  :resolve config.resolve
  :module config.module
  :plugins $ array
    new webpack.optimize.CommonsChunkPlugin :vendor :vendor.[chunkhash:8].js
    new webpack.optimize.UglifyJsPlugin $ object (:sourceMap false)
    \ ()
      this.plugin :done $ \ (stats)
        var
          json $ stats.toJson
          content $ JSON.stringify json.assetsByChunkName null 2
        return $ fs.writeFileSync :build/assets.json content
