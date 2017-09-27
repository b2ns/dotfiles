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

  //HashTable
  ds.HashTable=Class(
    {
      _init:function () {
        this._table = new Object();
        this._length=0;
      },
      length:function () {
        return this._length;
      },
      value:function (key) {
        return this._table[key];
      },
      insert:function (key,val) {
        if(val!==undefined){
          this._table[key]=val;
          this._length++;
        }
      },
      delete:function (key) {
        if(this._table[key]!==undefined){
          delete this._table[key];
          this._length--;
        }
      },
      find:function (key) {
        return this.value(key) !== undefined;
      },
      clear:function () {
        this._init();
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
      length:function () {
        return this._array.length;
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
      },
      clear:function () {
        this._init();
      }
    }
  );

  //Queue
  ds.Queue=Class(
    {
      _init:function (size) {
        this._array = new Array();
      },
      length:function () {
        return this._array.length;
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
      },
      clear:function () {
        this._init();
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
        this._tail=new ListNode();
        this._head.next=this._tail;
        this._tail.pre=this._head;
        this._length=0;
      },
      length:function () {
        return this._length;
      },
      insert:function (val,nodeVal) {
        var node=(nodeVal)?this.find(nodeVal):this._tail.pre;
        node=(node)?node:this._tail.pre;

        var newNode=new ListNode(val,node,node.next);
        node.next.pre=newNode;
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
        while(node!==this._tail){
          if(node.val === val) break;
          node=node.next;
        }
        return (node===this._tail)?undefined:node;
      },
      clear:function () {
        this._init();
      },
      forEach:function (func) {
        var node=this._head.next;
        while(node!==this._tail){
          func.call(this,node.val);
          node=node.next;
        }
      },
    }
  );

  //BinarySearchTree
  var TreeNode=Class(
    {
      _init:function (val,height,parent,left,right) {
        this.val=val;
        this.height=height;
        this.parent=parent;
        this.left=left;
        this.right=right;
      },
    }
  );

  ds.BST=Class(
    {
      _init:function () {
        // this._root=new TreeNode(undefined,0);
        this._root=undefined;
        this._length=0;
      },
      length:function () {
        return this._length;
      },
      insert:function (val) {
        if(this._root){
          var node=this._root,parent;
          while(node){
            parent=node;
            if(val<node.val){
              node=node.left;
            }
            else if(val>node.val){
              node=node.right;
            }
            else
              return undefined;
          }
          var newNode=new TreeNode(val,0,parent);
          if(val<parent.val)
            parent.left=newNode;
          else
            parent.right=newNode;
        }else{
          this._root=new TreeNode(val,0,undefined);
        }
      },
      find:function (val) {
        var node=this._root;
        while(node){
          if(val<node.val)
            node=node.left;
          else if(val>node.val)
            node=node.right;
          else
            return true;
        }
        return false;
      },
      _minmax:function (root,lr) {
        var node=root;
        if(node){
          for(;node[lr];node=node[lr]) ;
        }
        return node;
      },
      min:function () {
        var node=this._minmax(this._root,"left");
        return node&&node.val;
      },
      max:function () {
        var node=this._minmax(this._root,"right");
        return node&&node.val;
      },
      delete:function (val) {
        var node=this._root;
        if(node){
          while(node){
            if(val<node.val)
              node=node.left;
            else if(val>node.val)
              node=node.right;
            else{
              if(node.left){
                var maxNode=this._minmax(node.left,"right");
                node.val=maxNode.val;
                if(maxNode===node.left)
                  node.left=maxNode.left;
                else
                  maxNode.parent.right=maxNode.left;
              }else if(node.right){
                var minNode=this._minmax(node.right,"left");
                node.val=minNode.val;
                if(minNode===node.right)
                  node.right=minNode.right;
                else
                  minNode.parent.left=minNode.right;
              }else{
                if(node.parent){
                  if(node.val<node.parent.val)
                    node.parent.left=undefined;
                  else
                    node.parent.right=undefined;
                }else{
                  this._root=undefined;
                }
              }
              break;
            }
          }
        }
      },
      clear:function () {
        this._init();
      },
      forEachPre:function (func) {
        this._forEachPre(this._root,func);
      },
      _forEachPre:function (node,func) {
        if(node){
          func.call(this,node.val);
          this._forEachPre(node.left,func);
          this._forEachPre(node.right,func);
        }
      },
      forEachMid:function (func) {
        this._forEachMid(this._root,func);
      },
      _forEachMid:function (node,func) {
        if(node){
          this._forEachMid(node.left,func);
          func.call(this,node.val);
          this._forEachMid(node.right,func);
        }
      },
      forEachPost:function (func) {
        this._forEachPost(this._root,func);
      },
      _forEachPost:function (node,func) {
        if(node){
          this._forEachPost(node.left,func);
          this._forEachPost(node.right,func);
          func.call(this,node.val);
        }
      },
    }
  );


  //PriorityQueue

  //Graph

  //Digraph


  
  //expose the ds
  exports.ds=ds;
})(window);
