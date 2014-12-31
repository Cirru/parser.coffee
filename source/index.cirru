
doctype

html
  head
    title Cirru
    meta (:charset utf-8)
    script(:src build/vendor.min.js)
    link (:rel icon)
      :href http://logo.cirru.org/cirru-32x32.png?v=3
    @if (@ dev)
      @block
        link (:rel stylesheet) (:href source/main.css)
        script (:defer) (:src build/main.js)
      @block
        link (:rel stylesheet) (:href build/main.min.css)
        script (:defer) (:src build/main.min.js)
  body
    textarea.demo.source $ :placeholder "Source Code"
    textarea.demo.target $ :placeholder "Compiled Data"
    @insert ./ga.html
