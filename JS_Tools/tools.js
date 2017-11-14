/*
 *Description: some useful tools for JavaScript
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
	return {
	  interfaceName:name,
	  methods: methods
	};
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

	  this.prototype._super=dad.prototype;
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
	  }
	}
	return this;
  };
  // implements
  var implement=function (interfaces){
	for(var i=0,len=arguments.length;i<len;i++){
	  var interf=arguments[i];
	  if(!interf.interfaceName) continue;
	  for(var j=0,len2=interf.methods.length;j<len2;j++){
		var method=interf.methods[j];
		if(!this.prototype[method] || typeof this.prototype[method]!=="function")
		  throw new Error("Class '"+this.prototype.className+"' does not implements Method '"
			  +method+"' in Interface '"+interf.interfaceName+"'!");
	  }
	}
	return this
  };
  // class
  _.class=function (className,member){
	if(arguments.length!==2)
	  throw new Error("_.class needs two arguments!");

	var Class=function (){
	  this._init.apply(this,arguments);
	};
	Class.extends=extend;
	Class.implements=implement;

	Class.prototype._super=Object.prototype;
	Class.prototype._init=function (){};
	Class.prototype.className=className;

	for(var m in member){
	  if(member.hasOwnProperty(m))
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
  /* exact type of variable */
  _.typeof=function (variable){
	if(variable.className)
	  return variable.className;
	return Object.prototype.toString.call(variable).slice(8, -1);
  };
  /* bind this to a certain object */
  _.proxy=function (that,fn){
	return function (){
	  return fn.apply(that,arguments);
	};
  };


  
})(window);
