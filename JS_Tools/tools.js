/*
 *Description: some useful tools for javascript
 *Author: b2ns
 */

(function (exports){
  "use strict";
  /* every thing bind to the function '_' */
  var _=function (){};
  /* save previous _ */
  var previous_=exports._;
  /* export to global */
  exports.Tools=exports._=_;
  /* when conflict with others */
  _.noConflict=function (name){
	exports._=previous_;
	exports[name]=this;
  };

  /********** TOOLS DEFINE AFTER THIS LINE **********/

  /***** Class And Object *****/
  /* define a interface */
  _.interface=function (name,methodArr){
	if(arguments.length!==2)
	  throw new Error("_.interface needs two arguments!");
	var methods=[];
	for(var i=0,len=methodArr.length;i<len;i++)
	  if(typeof methodArr[i] === "string")
		methods.push(methodArr[i]);

	var interfaces=function (){
	  throw new Error("Interface '"+interfaces._name+"' can not make an instance");
	};
	interfaces._name=name;
	interfaces._methods=methods;
	return interfaces;
  };
  /* define a class and support multiple extends */
  // extends
  var extend=function (dad){
	var len=arguments.length;
	var tmpproto=this.prototype;
	if(typeof dad === "function"){
	  var F=function (){};
	  F.prototype=dad.prototype;
	  this.prototype=new F();

	  for(var m in tmpproto){
		if(tmpproto.hasOwnProperty(m))
		  this.prototype[m]=tmpproto[m];
	  }

	  this.prototype.super=dad.prototype;
	  this.prototype.superClassName.push(dad._name||dad.name);
	}
	// multiple extends using mixin
	if(len>1){
	  for(var i=1;i<len;i++){
		var dad=arguments[i];
		if(typeof dad !== "function") continue;
		for(var m in dad.prototype){
		  if(!this.prototype[m])
			this.prototype[m]=dad.prototype[m];
		}
		this.prototype.superClassName.push(dad._name||dad.name);
	  }
	}
	return this;
  };
  // implements
  var implement=function (interfaces){
	for(var i=0,len=arguments.length;i<len;i++){
	  var interf=arguments[i];
	  if(!interf._name) continue;
	  for(var j=0,len2=interf._methods.length;j<len2;j++){
		var method=interf._methods[j];
		if(!this.prototype[method] || typeof this.prototype[method]!=="function")
		  throw new Error("Class '"+this.prototype.className+"' does not implements Method '"+method+"' in Interface '"+interf._name+"'!");
	  }
	  this.prototype.interfaceName.push(interf._name);
	}
	return this
  };
  // show all the public methods
  var methods=function (){
    var arr=[];
	for(var m in this){
	  var method=this[m];
	  if(typeof method==="function" && method.name.search(/^_[a-z0-9_$]*/gi)===-1 && method.name!=="methods")
		arr.push(method.name);
	}
	return arr;
  };
  // class
  _.class=function (className,member){
	if(arguments.length!==2)
	  throw new Error("_.class needs two arguments!");

	var init=member.init||function (){};
	var Class=function (){
	  Class.init.apply(this,arguments);
	};
	Class.init=init;
	Class._name=className;
	Class.extends=extend;
	Class.implements=implement;

	Class.prototype.className=className;
	Class.prototype.superClassName=[];
	Class.prototype.interfaceName=[];
	Class.prototype.super=Object.prototype;
	Class.prototype.methods=methods;

	for(var m in member){
	  if(member.hasOwnProperty(m) && !Class.prototype[m] && m!=="init")
		Class.prototype[m]=member[m];
	}
	return Class;
  };
  /* clone an object */
  _.clone=function (obj){
	if(!obj) return;
	var F=function (){};
	F.prototype=obj;
	return new F();
  };
  /* make a singleton or a lazy loading one*/
  _.singleton=function (constructor,isLazy){
	if(isLazy!==true)
	  return constructor();
	else{
	  var instance;
	  return {
		getInstance: function (){
		  return (instance)?instance:instance=constructor();
		}
	  };
	}
  };

  /***** normal use *****/
  /* loop */
  _.loop=function (fn,N){
    N=N||1;
	for(var i=0;i<N;i++)
	  fn(i);
  };
  /* random number */
  _.random=function (a,b){
	switch(arguments.length){
	  case 0: a=0,b=100;break;
	  case 1: b=a,a=0;break;
	  default: ;
	}
	return a+Math.floor(Math.random()*(b-a+1));//include right num
  };
  /* random string */
  _.randomStr=function (length){
    var length=length||5;
	var arr=new Array(length);
	while(length--){
	  arr[length]=String.fromCharCode(Math.floor(Math.random()*26)+97);
	}
	return arr.join("");
  };
  /* timer */
  _.Timer=_.class("Timer",{
	_init: function (){
	  this._time=0;
	},
	start: function (){
	  this._time=Date.now();
	},
	end: function (){
	  var tmp=Date.now()-this._time;
	  console.log(tmp+" ms");
	  return tmp;
	},
  });
  /* counter */
  _.Counter=_.class("Counter",{
	_init: function (num){
	  this._count=num||0;
	},
	show: function (){
	  return this._count;
	},
	add: function (num){
	  num=num||1;
	  if(num<0) num=-num;
	  return this._count+=num;
	},
	sub: function (num){
	  num=num||1;
	  if(num<0) num=-num;
	  return this._count-=num;
	},
	reset:function (num){
	  return this._count=num||0;
	},
  });

  /***** Other Stuff Related To JavaScript *****/
  /* exact type */
  _.typeof=function (obj){
	if(obj && obj.className)
	  return obj.className;
	return Object.prototype.toString.call(obj).slice(8, -1);
  };
  /* is instance of a class or implements a interface*/
  _.instanceof=function (obj,type){
	var objtype=typeof obj;
	if(objtype==="object" || objtype==="function"){
	  if(obj instanceof type)
		return true;
	  if(obj && obj.interfaceName && (obj.interfaceName.indexOf(type._name||type.name)!==-1 || obj.superClassName.indexOf(type._name||type.name)!==-1))
		return true;
	}
	else if(objtype!=="undefined" && new Object(obj) instanceof type)
	  return true;

	return false;
  };
  /* bind 'this' to a certain object */
  _.bind=function (that,fn){
	return function (){
	  return fn.apply(that,arguments);
	};
  };


  
})(window);
