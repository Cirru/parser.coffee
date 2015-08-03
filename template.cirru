
var
  fs $ require :fs
  stir $ require :stir-template
  (object~ html head title meta link script body div textarea) stir

= module.exports $ \ (data)
  return $ stir.render
    stir.doctype
    html null
      head null
        title null ":Cirru Parser"
        meta $ object (:charset :utf-8)
        link $ object (:rel :icon)
          :href :http://logo.cirru.org/cirru-32x32.png
        link $ object (:rel :stylesheet)
          :href :src/main.css
        script $ object (:src data.vendor) (:defer true)
        script $ object (:src data.main) (:defer true)
        cond data.dev undefined
          fs.readFileSync :src/ga.html :utf8
      body null
        textarea $ {} (:class ":demo source") (:placeholder ":Source Code")
        textarea $ {} (:class ":demo target") (:placeholder ":Compiled Code")
