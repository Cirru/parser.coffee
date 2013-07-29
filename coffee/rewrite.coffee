
Array::__defineGetter__ 'last', -> @[@length - 1]
Array::__defineGetter__ 'now', -> @[@length - 1]
Array::__defineGetter__ 'init', -> @[...(@length - 1)]
Array::__defineGetter__ 'head', -> @[0]
Array::__defineGetter__ 'body', -> @[1..]

String::__defineGetter__ 'last', -> @[@length - 1]
String::__defineGetter__ 'init', -> @[...(@length - 1)]
String::__defineGetter__ 'head', -> @[0]
String::__defineGetter__ 'body', -> @[1..]
