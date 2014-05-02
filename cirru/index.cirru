
doctype

html
  head
    title $ = Cirru
    script (:defer) $ :src build/build.js
    link (:rel stylesheet) $ :href css/page.css
    link (:rel icon)
      :href http://logo.cirru.org/cirru-32x32.png?v=3
  body
    textarea.demo.source $ :placeholder "Source Code"
    textarea.demo.target $ :placeholder "Compiled Data"
    @insert ../html/ga.html