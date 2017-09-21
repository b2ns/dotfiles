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
        if(Object.prototype.toString.call(attr[i]) === "[object Array]"){
          this[i]=new Array();
        }else if(Object.prototype.toString.call(attr[i]) === "[object Object]"){
          this[i]=new Object();
        }else{
          this[i]=attr[i];
        }
      }
      for(var i in obj){
        this[i]=obj[i];
      }
      this.init();
    };

    if(typeof parent === "function"){
      var tmp = function(){};
      tmp.prototype=parent.prototype;
      $class.prototype=new tmp;
    }

    $class.fn=$class.prototype;
    $class.fn.init=function (){console.log("init");};
    for(var i in method){
      $class.fn[i]=method[i];
    }
    return $class;
  };
  ds.Class=Class;

  //Bag
  ds.Bag=Class(
    {
      $array: []
    },
    {
      getSize:function () {
        return this.$array.length;
      },
      push:function (item) {
        this.$array.push(item);
      },
      pick:function () {
        return this.$array[Math.floor(Math.random()*this.getSize())];
      },
      find:function (item) {
        return this.$array.indexOf(item)!==-1;
      },
    }
  );

  //Stack
  ds.Stack=Class(
    {
      $array:[]
    },
    {
      push:function (item) {
        this.$array.push(item);
      },
      pop:function () {
        return this.$array.pop();
      },
      top:function () {
        return this.$array[this.$array.length-1];
      }
    }
  );

  //Queue
  ds.Queue=Class(
    {
      $array:[]
    },
    {
      enqueue:function (item) {
        this.$array.push(item);
      },
      dequeue:function () {
        return this.$array.shift();
      },
      first:function () {
        return this.$array[0];
      },
      last:function () {
        return this.$array[this.$array.length-1];
      }
    }
  );


  
  //expose the ds
  exports.ds=ds;
})(window);
