/*
*Description: A set of basic data structures for JavaScript
*Author: b2ns 
*/

(function (exports) {
  var ds=function(){};

  //make it easier to define a new class
  var Class = function (attr,method,parent) {
    var $class=function (obj) {
      for(var i in attr){
        this[i]=attr[i];
      }
      for(var i in obj){
        this[i]=obj[i];
      }
      if(typeof this.init === "function") this.init();
    };

    if(typeof parent === "function"){
      var tmp = function(){};
      tmp.prototype=parent.prototype;
      $class.prototype=new tmp;
    }

    $class.fn=$class.prototype;
    for(var i in method){
      $class.fn[i]=method[i];
    }
    return $class;
  };
  ds.Class=Class;

  //Bag
  ds.Bag=Class(
    {
      size:0,
    },
    {
      setSize:function (size) {
        this.size=size;
      },
    }
  );


  
  //expose the ds
  exports.ds=ds;
})(window);
