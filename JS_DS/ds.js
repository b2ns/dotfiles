/*
*Description: A set of basic data structures for JavaScript
*Author: b2ns 
*/

(function (exports) {
  var ds=function(){};

  //make it easier to define a new class
  var Class = function (method,parent) {
    var _class=function () {
      this._init.apply(this,arguments);
    };

    if(typeof parent === "function"){
      var tmp = function(){};
      tmp.prototype=parent.prototype;
      _class.prototype=new tmp;
      _class.prototype.constructor=_class;
    }

    _class.fn=_class.prototype;
    _class.fn._init=function (){};
    for(var i in method){
      _class.fn[i]=method[i];
    }
    return _class;
  };
  ds.Class=Class;

  //hashTable
  ds.hashTable=Class(
    {
      _init:function () {
        this._table = new Object();
      },
      value:function (key) {
        return this._table[key];
      },
      insert:function (key,val) {
        this._table[key]=val;
      },
      delete:function (key) {
        delete this._table[key];
      },
      find:function (key) {
        return this.value(key) !== undefined;
      },
      clear:function () {
        this._table=new Object();
      },
      forEach:function (func) {
        for(var key in this._table){
          func.call(this,key,this._table[key]);
        }
      },
    }
  );

  //Stack
  ds.Stack=Class(
    {
      _init:function () {
        this._array = new Array();
      },
      push:function (item) {
        this._array.push(item);
      },
      pop:function () {
        return this._array.pop();
      },
      top:function () {
        return this._array[this._array.length-1];
      },
      bottom:function () {
        return this._array[0];
      }
    }
  );

  //Queue
  ds.Queue=Class(
    {
      _init:function (size) {
        this._array = new Array();
      },
      enqueue:function (item) {
        this._array.push(item);
      },
      dequeue:function () {
        return this._array.shift();
      },
      first:function () {
        return this._array[0];
      },
      last:function () {
        return this._array[this._array.length-1];
      }
    }
  );

  //List
  var ListNode=Class(
    {
      _init:function (val,pre,next) {
        this.val=val;
        this.pre=pre;
        this.next=next;
      }
    }
  );

  ds.List=Class(
    {
      _init:function () {
        this._head=new ListNode();
        this._length=0;
      },
      length:function () {
        return this._length;
      },
      insert:function (val,nodeVal) {
        var node=(nodeVal)?this.find(nodeVal):this._head;
        node=(node)?node:this._head;

        var newNode=new ListNode(val,node,node.next);
        if(node.next){
          node.next.pre=newNode;
        }
        node.next=newNode;

        this._length++;
      },
      delete:function (val) {
        var node=this.find(val);
        if(node){
          node.pre.next=node.next;
          node.next.pre=node.pre;
        }

        this._length--;
      },
      find:function (val) {
        var node=this._head.next;
        while(node){
          if(node.val === val) break;
          node=node.next;
        }
        return node;
      },
      clear:function () {
        this._head=new ListNode();
        this._length=0;
      },
      forEach:function (func) {
        var node=this._head.next;
        while(node){
          func.call(this,node.val);
          node=node.next;
        }
      },
    }
  );

  
  //expose the ds
  exports.ds=ds;
})(window);
