/*
 *Description: a javascript module loader
 *Author: b2ns
 */

(function (exports) {
  var callbackArr = [],
      existMod = document.getElementsByTagName("script");

  window.addEventListener("load", function () {
    while (callbackArr.length > 0) {
      callbackArr.pop()();
    }
  });

  exports.include = function (relyonModArr, func) {
    for (var i = relyonModArr.length - 1; i >= 0; i--) {
      var src = relyonModArr[i];

      for (var j = 0,len = existMod.length; j < len; j++) {
        if (existMod[j].src.search(src) >= 0) {
          break;
        }
      }
      if (j == len) {
        var relyonMod = document.createElement("script");
        relyonMod.src = src;
        document.body.appendChild(relyonMod);
      }
    }
    callbackArr.push(func);
  };
})(window);
