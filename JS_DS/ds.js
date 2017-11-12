/*
*Description: A set of basic data structures for JavaScript
*Author: b2ns 
*/

(function (exports) {
  "use strict";
  //make it easier to define a new class
  var Class = function (method, parent) {
    var _class = function () {
      this._init.apply(this, arguments);
    };
    _class.prototype._super = Object.prototype;
    if (typeof parent === "function") {
      var tmp = function () { this.constructor = _class; };
	  tmp.prototype = parent.prototype;
	  _class.prototype = new tmp();
	  _class.prototype._super = parent.prototype;
    }
    _class.prototype._init = function () { };
    for (var i in method) {
      if (method.hasOwnProperty(i))
        _class.prototype[i] = method[i];
    }
    return _class;
  };

  //ds
  var ds = Class({
    foo: function () {
      console.log("foo from ds");
    },
    length: function () {
      if (this._length !== undefined)
        return this._length;
      if (this._body !== undefined)
        return this._body.length;
    },
    clear: function () {
      this._init(this._cmp);
    }
  });
  exports.ds = ds; //expose the ds

  //HashTable
  ds.HashTable = Class({
    _init: function () {
      this._body = new Object();
      this._length = 0;
    },
    find: function (key) {
      return this._body[key];
    },
    insert: function (key, val) {
      if (val !== undefined) {
        this._body[key] = val;
        this._length++;
        return val;
      }
    },
    delete: function (key) {
      if (this._body[key] !== undefined) {
        var tmp = this._body[key];
        delete this._body[key];
        this._length--;
        return tmp;
      }
    },
    forEach: function (func) {
      for (var key in this._body) {
        if (this._body.hasOwnProperty(key))
          func.call(this, this._body[key], key);
      }
    }
  }, ds);

  //Set
  ds.Set = Class({
    _init: function () {
      this._body = new ds.HashTable();
    },
    length: function () {
      return this._body.length();
    },
    insert: function (val) {
      return this._body.insert(val, val);
    },
    delete: function (val) {
      return this._body.delete(val);
    },
    find: function (val) {
      return this._body.find(val);
    },
    forEach: function (func) {
      this._body.forEach(func);
    },
    intersect: function (set) {
      var result = new ds.Set();
      if (set) {
        this.forEach(function (val) {
          if (set.find(val))
            result.insert(val);
        });
      }
      return result;
    },
    union: function (set) {
      var result = new ds.Set();
      this.forEach(function (val) {
        result.insert(val);
      });
      if (set) {
        set.forEach(function (val) {
          result.insert(val);
        });
      }
      return result;
    },
    complement: function (set) {
      var result = new ds.Set();
      if (set) {
        this.forEach(function (val) {
          if (set.find(val) === undefined)
            result.insert(val);
        });
      } else {
        this.forEach(function (val) {
          result.insert(val);
        });
      }
      return result;
    },
  }, ds);

  //Stack
  ds.Stack = Class({
    _init: function () {
      this._body = new Array();
    },
    push: function (item) {
      this._body.push(item);
      return item;
    },
    pop: function () {
      return this._body.pop();
    },
    top: function () {
      return this._body[this._body.length - 1];
    },
    bottom: function () {
      return this._body[0];
    },
  }, ds);

  //Queue
  ds.Queue = Class({
    _init: function () {
      this._body = new Array();
    },
    enqueue: function (item) {
      this._body.push(item);
      return item;
    },
    dequeue: function () {
      return this._body.shift();
    },
    first: function () {
      return this._body[0];
    },
    last: function () {
      return this._body[this._body.length - 1];
    },
  }, ds);

  //List
  var ListNode = Class({
    _init: function (val, pre, next) {
      this.val = val;
      this.pre = pre;
      this.next = next;
    }
  });

  ds.List = Class({
    _init: function (cmp) {
      this._head = new ListNode();
      this._tail = new ListNode();
      this._head.next = this._tail;
      this._tail.pre = this._head;
      this._length = 0;
      this._cmp = cmp || function (a, b) { return (a === b) ? 0 : 1; };
    },
    insert: function (val, nodeVal) {
	  var node;
	  if(nodeVal === undefined || (node=this._find(nodeVal)) === undefined)
		node=this._tail.pre;

      var newNode = new ListNode(val, node, node.next);
      node.next.pre = newNode;
      node.next = newNode;

      this._length++;
      return val;
    },
    delete: function (val) {
      var node = this._find(val);
      if (node) {
        node.pre.next = node.next;
        node.next.pre = node.pre;
        this._length--;
        return val;
      }
    },
    find: function (val) {
      var node = this._find(val);
      return node && node.val;
    },
    _find: function (val) {
      var node = this._head.next;
      while (node !== this._tail) {
        if (this._cmp(val, node.val) === 0) break;
        node = node.next;
      }
      return (node === this._tail) ? undefined : node;
    },
    forEach: function (func) {
      var node = this._head.next;
      while (node !== this._tail) {
        func.call(this, node.val);
        node = node.next;
      }
    },
  }, ds);

  //BinarySearchTree
  var TreeNode = Class({
    _init: function (val, height, parent, left, right) {
      this.val = val;
      this.height = height;
      this.parent = parent;
      this.left = left;
      this.right = right;
    },
  });

  ds.BST = Class({
    _init: function (cmp) {
      this._root = undefined;
      this._length = 0;
      this._cmp = cmp || function (a, b) { return (a > b) ? 1 : ((a < b) ? -1 : 0); };
    },
    _height: function (node) {
      return (node) ? node.height : -1;
    },
    _maxHeight: function (left, right) {
      var lh = this._height(left);
      var rh = this._height(right);
      return (lh > rh) ? lh : rh;
    },
    _rotate: function (lr, sd, node) {
      var topNode, tmp;
      if (lr === "left" && sd === "single") {
        topNode = node.left;
        topNode.parent = node.parent;
        node.left = topNode.right; if (topNode.right) topNode.right.parent = node;
        topNode.right = node; node.parent = topNode;
      } else if (lr === "right" && sd === "single") {
        topNode = node.right;
        topNode.parent = node.parent;
        node.right = topNode.left; if (topNode.left) topNode.left.parent = node;
        topNode.left = node; node.parent = topNode;
      } else if (lr === "left" && sd === "double") {
        topNode = node.left.right;
        tmp = node.left;
        topNode.parent = node.parent;
        node.left = topNode.right; if (topNode.right) topNode.right.parent = node;
        tmp.right = topNode.left; if (topNode.left) topNode.left.parent = tmp;
        topNode.right = node; node.parent = topNode;
        topNode.left = tmp; tmp.parent = topNode;
      } else if (lr === "right" && sd === "double") {
        topNode = node.right.left;
        tmp = node.right;
        topNode.parent = node.parent;
        node.right = topNode.left; if (topNode.left) topNode.left.parent = node;
        tmp.left = topNode.right; if (topNode.right) topNode.right.parent = tmp;
        topNode.left = node; node.parent = topNode;
        topNode.right = tmp; tmp.parent = topNode;
      }
      node.height = 1 + this._maxHeight(node.left, node.right);
      if (tmp) tmp.height = 1 + this._maxHeight(tmp.left, tmp.right);
      topNode.height = 1 + this._maxHeight(topNode.left, topNode.right);
      return topNode;
    },
    _AVL: function (newNode) {
      for (var node = newNode.parent, topNode; node; node = node.parent, topNode = undefined) {
        if (this._height(node.left) - this._height(node.right) >= 2) {
          if (this._height(node.left.left) >= this._height(node.left.right)) {
            topNode = this._rotate("left", "single", node);
          } else {
            topNode = this._rotate("left", "double", node);
          }
        } else if (this._height(node.right) - this._height(node.left) >= 2) {
          if (this._height(node.right.left) > this._height(node.right.right)) {
            topNode = this._rotate("right", "double", node);
          } else {
            topNode = this._rotate("right", "single", node);
          }
        } else {
          node.height = 1 + this._maxHeight(node.left, node.right);
        }
        if (topNode) {
          if (topNode.parent) {
            if (this._cmp(topNode.val, topNode.parent.val) === -1) {
              topNode.parent.left = topNode;
            } else {
              topNode.parent.right = topNode;
            }
          } else {
            this._root = topNode;
          }
        }
      }
    },
    insert: function (val) {
      if (this._root) {
        var node = this._root, parent;
        while (node) {
          parent = node;
          if (this._cmp(val, node.val) === -1) {
            node = node.left;
          }
          else if (this._cmp(val, node.val) === 1) {
            node = node.right;
          }
          else
            return undefined;
        }
        var newNode = new TreeNode(val, 0, parent);
        if (this._cmp(val, parent.val) === -1)
          parent.left = newNode;
        else
          parent.right = newNode;

        this._AVL(newNode);
      } else {
        this._root = new TreeNode(val, 0, undefined);
      }
      this._length++;
      return val;
    },
    find: function (val) {
      if (val === undefined) return undefined;
      var node = this._root;
      while (node) {
        if (this._cmp(val, node.val) === -1)
          node = node.left;
        else if (this._cmp(val, node.val) === 1)
          node = node.right;
        else
          return node.val;
      }
      return undefined;
    },
    _minmax: function (root, lr) {
      var node = root;
      if (node) {
        for (; node[lr]; node = node[lr]);
      }
      return node;
    },
    min: function () {
      var node = this._minmax(this._root, "left");
      return node && node.val;
    },
    max: function () {
      var node = this._minmax(this._root, "right");
      return node && node.val;
    },
    delete: function (val) {
      if (val === undefined) return undefined;
      var node = this._root;
      while (node) {
        if (this._cmp(val, node.val) === -1)
          node = node.left;
        else if (this._cmp(val, node.val) === 1)
          node = node.right;
        else {
          var tmp = node.val;
          if (node.left) {
            var maxNode = this._minmax(node.left, "right");
            node.val = maxNode.val;
            if (maxNode === node.left)
              node.left = maxNode.left;
            else
              maxNode.parent.right = maxNode.left;
            if (maxNode.left) maxNode.left.parent = maxNode.parent;
            this._AVL(maxNode);
          } else if (node.right) {
            var minNode = this._minmax(node.right, "left");
            node.val = minNode.val;
            if (minNode === node.right)
              node.right = minNode.right;
            else
              minNode.parent.left = minNode.right;
            if (minNode.right) minNode.right.parent = maxNode.parent;
            this._AVL(minNode);
          } else {
            if (node.parent) {
              if (this._cmp(node.val, node.parent.val) === -1)
                node.parent.left = undefined;
              else
                node.parent.right = undefined;
            } else {
              this._root = undefined;
            }
            this._AVL(node);
          }
          this._length--;
          return tmp;
        }
      }
    },
    forEachPre: function (func) {
      this._forEachPre(this._root, func);
    },
    _forEachPre: function (node, func) {
      if (node) {
        func.call(this, node.val);
        this._forEachPre(node.left, func);
        this._forEachPre(node.right, func);
      }
    },
    forEachMid: function (func) {
      this._forEachMid(this._root, func);
    },
    _forEachMid: function (node, func) {
      if (node) {
        this._forEachMid(node.left, func);
        func.call(this, node.val);
        this._forEachMid(node.right, func);
      }
    },
    forEachPost: function (func) {
      this._forEachPost(this._root, func);
    },
    _forEachPost: function (node, func) {
      if (node) {
        this._forEachPost(node.left, func);
        this._forEachPost(node.right, func);
        func.call(this, node.val);
      }
    },
    forEachLevel: function (func) {
      var q = new ds.Queue();
      var node = this._root;
      if (node)
        q.enqueue(node);
      while (q.length() > 0) {
        node = q.dequeue();
        func.call(this, node.val);
        if (node.left)
          q.enqueue(node.left);
        if (node.right)
          q.enqueue(node.right);
      }
    },
  }, ds);

  //PriorityQueue
  ds.PQ = Class({
    _init: function (cmp) {
      this._body = new Array(1);
      this._cmp = cmp || function (a, b) { return (a > b) ? 1 : ((a < b) ? -1 : 0); };
    },
    length: function () {
      return this._body.length - 1;
    },
    insert: function (val) {
      var len = this._body.length;
      this._body.push(val);
      for (var j = len, i = Math.floor(len / 2); i > 0 && this._cmp(val, this._body[i]) === -1; j = i, i = Math.floor(i / 2)) {
        this._body[j] = this._body[i];
      }
      if (j !== len)
        this._body[j] = val;
      return val;
    },
    top: function () {
      return this._body[1];
    },
    delete: function () {
      var len = this.length();
      if (len <= 0) return undefined

      var top = this._body[1],
        last = this._body[len--];
      for (var j = 1, i = 2; i <= len; j = i, i *= 2) {
        if (this._cmp(this._body[i], this._body[i + 1]) === 1)
          i++;
        if (this._cmp(last, this._body[i]) === 1)
          this._body[j] = this._body[i];
        else
          break;
      }
      this._body[j] = last;
      this._body.pop();
      return top;
    },
    forEach: function (func) {
      for (var i = 1, len = this.length(); i <= len; i++) {
        func.call(this, this._body[i]);
      }
    },
  }, ds);

  //Graph
  ds.Graph = Class({
    _init: function () {
	  this._body=new Array(10000);
	  this._hash=new ds.HashTable();
	  this._rehash=new ds.HashTable();
	  this._length=0;
	  this._endIndex=0;
	  this._emptyPos=new ds.Stack();
	  this._cmp=function (a,b){
	    return (a.n>b.n)?1:((a.n<b.n)?-1:0);
	  }
    },
    numOfVertex: function () {
	  return this._length;
    },
	numOfEdge: function (){
	  var n=0;
	  for(var i=0;i<this._endIndex;i++){
		if(this._body[i]!==undefined)
		  n+=this._body[i].length();
	  }
	  return n/2;
	},
	_addNum: function (v){
	  var n=this._hash.find(v);
	  if(n===undefined){
		n=(this._emptyPos.length()===0)?this._endIndex++:this._emptyPos.pop();
		this._hash.insert(v,n);
		this._rehash.insert(n,v);
		this._length++;
		this._body[n]=new ds.BST(this._cmp);
	  }
	  return n;
	},
	_delNum: function (v){
	  var n=this._hash.find(v);
	  if(n!==undefined){
		this._hash.delete(v);
		this._rehash.delete(n);
	    this._emptyPos.push(n);
		this._length--;
	  }
	  return n;
	},
	insertEdge: function (v1,v2,w){
	  if(v1===v2 || v2===undefined) return;
	  if(w===undefined) w=0;

	  var n1=this._addNum(v1),
		  n2=this._addNum(v2);
	  this._body[n1].insert({n:n2,w:w});
	  this._body[n2].insert({n:n1,w:w});

	},
	deleteEdge: function (v1,v2){
	  var n1=this._hash.find(v1),
		  n2=this._hash.find(v2);
	  if(n1!==undefined && n2!==undefined){
		this._body[n1].delete({n:n2});
		this._body[n2].delete({n:n1});
	  }
	},
	insertVertex:function (v,w){
	  if(w===undefined) w=0;
	  var n=this._addNum(v);
	  for(var i=0;i<this._endIndex;i++){
		if(this._body[i]===undefined || i===n) continue;
		this._body[n].insert({n:i,w:w});
		this._body[i].insert({n:n,w:w});
	  }
	},
	deleteVertex: function (v){
	  var n=this._delNum(v);
	  if(n!==undefined){
		var q=new ds.Queue();
		this._body[n].forEachMid(function (v){
		  q.enqueue(v);
		});
		this._body[n]=undefined;
		while(q.length()){
		  this._body[q.dequeue().n].delete({n:n});
		}
	  }
	},
	toString: function (){
	  var str="";
	  var q=new ds.Queue();
	  for(var i=0;i<this._endIndex;i++){
		if(this._body[i]===undefined) continue;

		str+=this._rehash.find(i)+":";
		this._body[i].forEachMid(function (v){
		  q.enqueue(v);
		});
		while(q.length()){
		  str+=this._rehash.find(q.first().n)+"-"+q.dequeue().w+",";
		}
		str+="\n";
	  }
	  return str;
	},
  },ds);

  //Digraph



})(window);
