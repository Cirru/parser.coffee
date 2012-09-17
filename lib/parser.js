var build, divide, err, esc, fold, has_content, inner, inspect, isArr, lef, maker, mle, mri, rig, sep, short, show, test1, tokenize, walk;

show = console.log;

isArr = Array.isArray;

err = function(info) {
  throw new Error(info);
};

inspect = require('util').inspect;

esc = '\\';

lef = '(';

rig = ')';

sep = ' ';

mle = 1;

mri = 2;

maker = function(arr) {
  return arr;
};

has_content = function(obj) {
  return obj.line.trim().length > 0;
};

inner = function(obj) {
  return obj.line.slice(0, 2) === '  ';
};

short = function(obj) {
  obj.line = obj.line.slice(2);
  return obj;
};

fold = function(arr) {
  var inner_append, res, ret;
  ret = [];
  inner_append = function(item) {
    var end;
    end = ret.length - 1;
    if ((ret[end] != null) && (isArr(ret[end]))) {
      return ret[end].push(short(item));
    } else {
      return ret.push([short(item)]);
    }
  };
  arr.forEach(function(item) {
    if (inner(item)) {
      return inner_append(item);
    } else {
      return ret.push(item);
    }
  });
  res = [];
  ret.forEach(function(item) {
    if (isArr(item)) {
      return res.push(fold(item));
    } else {
      return res.push(item);
    }
  });
  return res;
};

divide = function(arr) {
  var ret;
  ret = [];
  arr.forEach(function(item) {
    var end;
    end = ret.length - 1;
    if (isArr(item)) {
      if (!isArr(ret[end])) ret.push([]);
      end = ret.length - 1;
      return (divide(item)).forEach(function(x) {
        return ret[end].push(x);
      });
    } else {
      ret.push([]);
      end += 1;
      return ret[end].push(item);
    }
  });
  return ret;
};

tokenize = function(obj) {
  var count, isEsc, list, n, str, token;
  str = obj.line;
  n = obj.n;
  isEsc = false;
  count = 0;
  token = '';
  list = [];
  str.split('').forEach(function(c) {
    if (isEsc) {
      token += c;
      return isEsc = false;
    } else {
      if (c === esc) {
        return isEsc = true;
      } else if (c === lef) {
        if (token.length > 0) list.push(token);
        token = '';
        list.push(mle);
        return count += 1;
      } else if (c === rig) {
        if (token.length > 0) list.push(token);
        token = '';
        list.push(mri);
        return count -= 1;
      } else if (c === sep) {
        if (token.length > 0) list.push(token);
        return token = '';
      } else {
        return token += c;
      }
    }
  });
  if (isEsc) err("bad ESC at line " + n + ": \"" + str + "\"");
  if (count !== 0) err("bad parentheses at line " + n + ": \"" + str + "\"");
  if (str[0] === ' ') err("bad space at line " + n + ": \"" + str + "\"");
  if (token.length > 0) list.push(token);
  list.unshift(mle);
  list.push(mri);
  list.n = n;
  return list;
};

build = function(tokens) {
  var busy, len, mark, pos, ret;
  len = tokens.length;
  pos = 0;
  show('tokens: ', tokens);
  mark = function(str) {
    var obj;
    return obj = {
      n: tokens.n,
      line: str
    };
  };
  busy = function() {
    var c, tree;
    tree = [];
    while (pos < len) {
      c = tokens[pos];
      pos += 1;
      if (c === mle) {
        tree.push(busy());
      } else if (c === mri) {
        return tree;
      } else {
        tree.push(mark(c));
      }
    }
    return tree;
  };
  ret = busy();
  show(inspect(ret, true, null, true));
  return ret[0];
};

walk = function(arr) {
  var ret;
  ret = [];
  arr.forEach(function(item) {
    if (isArr(item)) {
      return ret.push(walk(item));
    } else {
      return (build(tokenize(item))).forEach(function(x) {
        return ret.push(x);
      });
    }
  });
  return ret;
};

test1 = function() {
  var n, obj, str;
  str = "((1 2 (\\(d) ) d (d))";
  n = 0;
  obj = {
    line: str,
    n: n
  };
  return show(build(tokenize(obj)));
};

exports.parser = function(str) {
  var material, n, res, ret, transfer;
  n = 0;
  material = [];
  transfer = function(item) {
    n += 1;
    return material.push({
      n: n,
      line: item
    });
  };
  str.split('\n').forEach(transfer);
  res = material.filter(has_content);
  ret = divide(fold(res));
  return walk(ret);
};
