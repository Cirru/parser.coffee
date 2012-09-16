var esc, fold, has_content, inner, isArr, lef, maker, rig, short, show;

show = console.log;

isArr = Array.isArray;

esc = '\\';

lef = '(';

rig = ')';

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
    if (ret[end] != null) {
      if ((ret[end] != null) && (isArr(ret[end]))) {
        return ret[end].push(short(item));
      } else {
        return ret.push([short(item)]);
      }
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

exports.parser = function(str) {
  var material, n, res, transfer;
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
  return fold(res);
};
