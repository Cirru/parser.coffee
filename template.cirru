

var env :dev

if (is process.env.env :release)
  do
    = env :release

var
  stir $ require :stir-template
  fs $ require :fs

  ({}~ html head title meta link script body div style textarea) stir

  logoUrl :http://logo.cirru.org/cirru-32x32.png
  cdnUrl $ cond (is process.env.local :true) : :http://cdn.tiye.me/parser.coffee/

console.log ":Running mode" (or process.env.env :dev)

var assets
case env
  :dev
    = assets $ {}
      :main $ + :http://localhost :: 8080 :/main.js
      :style null
  :release
    var assetsJson $ require :./dist/assets

    -- console.log ":Using CDN url:" (JSON.stringify cdnUrl)

    = assets $ {}
      :main assetsJson.main.js
      :style null

console.log ":Assets" assets

var html
  stir.render stir.doctype
    html null
      head null
        title null :Workflow
        meta $ {} :charset :utf-8
        link $ {} :rel :icon :href logoUrl
        cond (? assets.style)
          link $ {} :rel :stylesheet :href assets.style
        script $ {} :src assets.main :defer true
        style null ":body * {box-sizing: border-box;}"
      body ({} :style ":margin: 0;")
        div ({} :id :app)
          textarea $ {} (:class ":demo source") (:placeholder ":Source Code")
          textarea $ {} (:class ":demo target") (:placeholder ":Compiled Code")

fs.writeFileSync (cond (is process.env.env :release) :dist/index.html :index.html) html

console.log ":Write index.html"
