// Generated by CoffeeScript 1.6.3
(function() {
  var paint, q, req, source_file;

  source_file = "../cirru/indent.cr";

  q = function(query) {
    return document.querySelector(query);
  };

  req = new XMLHttpRequest;

  req.open("get", source_file);

  req.send();

  req.onload = function() {
    cirru.parse.compact = true;
    q("textarea.demo").value = req.response;
    return paint(req.response);
  };

  paint = function(text) {
    var lines, res;
    console.clear();
    res = cirru.parse(text, source_file);
    if (typeof compactJsonRender !== "undefined" && compactJsonRender !== null) {
      compactJsonRender.hide = true;
      lines = compactJsonRender(res);
    } else {
      lines = JSON.stringify(res);
    }
    q("pre.demo").innerHTML = lines;
    return console.log(res);
  };

  q("textarea.demo").addEventListener("keyup", function() {
    return paint(this.value);
  });

}).call(this);

/*
//@ sourceMappingURL=test.map
*/
