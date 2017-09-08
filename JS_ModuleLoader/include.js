/*
 *Description: a javascript module loader
 *Author: b2ns
 */

(function (host) {
  var CALLBACK = [];
  var CURMOD = document.getElementsByTagName("script");

  window.addEventListener("load", function () {
    while (CALLBACK.length > 0) {
      CALLBACK.pop()();
    }
  });

  host.include = function (relyonModArr, func) {
    for (var i = relyonModArr.length - 1; i >= 0; i--) {
      var src = relyonModArr[i];

      for (var j = 0,len = CURMOD.length; j < len; j++) {
        if (CURMOD[j].src.search(src) >= 0) {
          break;
        }
      }
      if (j == len) {
        var relyonMod = document.createElement("script");
        relyonMod.src = src;
        document.body.appendChild(relyonMod);
      }
    }
    CALLBACK.push(func);
  };
})(window);
