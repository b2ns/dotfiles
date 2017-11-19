/*
 *Description: some useful tools for javascript
 *Author: b2ns
 */

(function (root){
  "use strict";
  /* every thing bind to the function '_' */
  var _=function (){};

  /********** TOOLS DEFINE AFTER THIS LINE **********/
  /***** Class *****/
  /* to define a interface and support implements check */
  _.interface=function (name,methodArr){
	if(arguments.length!==2)
	  throw new Error("_.interface needs two arguments!");
	var methods=[];
	for(var i=0,len=methodArr.length;i<len;i++)
	  if(typeof methodArr[i] === "string")
		methods.push(methodArr[i]);

	var interfaces=function (){
	  throw new Error("Interface '"+interfaces._name+"' can not make an instance!");
	};
	interfaces._name=name;
	interfaces._methods=methods;
	return interfaces;
  };
  // implements
  Function.prototype.implements=function (interfaces){
	for(var i=0,len=arguments.length;i<len;i++){
	  var interf=arguments[i];
	  if(!interf._name) continue;
	  for(var j=0,len2=interf._methods.length;j<len2;j++){
		var method=interf._methods[j];
		if(typeof this.prototype[method]!=="function")
		  throw new Error("Class '"+this.prototype.className+"' does not implements Method '"+method+"' in Interface '"+interf._name+"'!");
	  }
	  this._interfaceName.push(interf._name);
	}
	return this
  };
  /* to define a class and support multiple extends */
  // all custom class will extends from this root class
  var ClassRoot=function (son){
	this.constructor=son;
  };
  ClassRoot.prototype={
	constructor: ClassRoot,
	super: Object.prototype,
	__type: function (){
	  return _.typeof(this);
	},
	__instanceof: function (Class){
	  return _.instanceof(this,Class);
	},
	__attributes: function (){
	  var arr=[];
	  for(var a in this){
		if(typeof this[a]!=="function" && a!=="super" && a.search(/^_[a-z0-9_$]*/gi)===-1)
		  arr.push(a);
	  }
	  return arr;
	},
	__methods:function (){
	  var arr=[];
	  for(var m in this){
		if(typeof this[m]==="function" && m!=="constructor" && m.search(/^_[a-z0-9_$]*/gi)===-1)
		  arr.push(m);
	  }
	  return arr;
	},
  };
  // class
  _.class=function (className,member){
	if(arguments.length!==2)
	  throw new Error("_.class needs two arguments!");

	var Class=function (){
	  if(Class._abstract){// check for abstract class
		throw new Error("Abstract Class '"+Class._name+"' can not make an instance!");
	  }
	  // extends attributes from superClass automatically
	  var args=[];
	  for(var i=0,len=arguments.length;i<len;++i)
		args[i]=arguments[i];
	  var superInitArr=[];
	  for(var superProto=this.super;superProto!==ClassRoot.prototype;superProto=superProto.super)
		superInitArr.push(superProto.constructor.init);
	  while(superInitArr.length){
		var superInit=superInitArr.pop();
		superInit.apply(this,args.splice(0,superInit.length));
	  }
	  Class.init.apply(this,args);// call own init
	};
	// all custom class will extends from ClassRoot
	Class.prototype=new ClassRoot(Class);

	// static property bind to Class
	Class.init=member.init||function (){};
	Class._name=className;
	Class._superClassName=[];
	Class._interfaceName=[];
	if(member.abstract)
	  Class._abstract=member.abstract;
	if(member.static){
	  for(var m in member.static)
		if(member.static.hasOwnProperty(m) && !Class[m])
		  Class[m]=member.static[m];
	}

	// default property in Class.prototype
	Class.prototype.super=ClassRoot.prototype;

	for(var m in member){
	  if(member.hasOwnProperty(m) && !Class.prototype[m] && m!=="init" && m!=="static" && m!=="abstract")
		Class.prototype[m]=member[m];
	}
	return Class;
  };
  // extends
  Function.prototype.extends=function (dad){
	var argsLen=arguments.length;
	var tmpProto=this.prototype;
	if(typeof dad === "function"){
	  var F=function (){};
	  F.prototype=dad.prototype;
	  this.prototype=new F();

	  for(var m in tmpProto){
		if(tmpProto.hasOwnProperty(m))
		  this.prototype[m]=tmpProto[m];
	  }

	  this.prototype.super=dad.prototype;
	  this._superClassName.push(dad._name||dad.name);
	}
	// multiple extends using mixin
	if(argsLen>1){
	  for(var i=1;i<argsLen;i++){
		var dad=arguments[i];
		if(typeof dad !== "function") continue;
		for(var m in dad.prototype){
		  if(!this.prototype[m])
			this.prototype[m]=dad.prototype[m];
		}
		this._superClassName.push(dad._name||dad.name);
	  }
	}
	// check for abstract method
	var superClass=this.prototype.super.constructor;
	if(superClass._abstract)
	  for(var i=0,len=superClass._abstract.length;i<len;i++){
		var method=superClass._abstract[i];
		if(typeof method!=="string") continue;
		if(typeof this.prototype[method]!=="function"){
		  this._abstract=superClass._abstract;break;
		}
	  }
	return this;
  };

  /***** Object *****/
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

  /***** String *****/
  /* to upper and lower case */
  var upperOrLowerCase=function (str,start,end,isUpper){
	if(typeof str!=="string") return;

	var strLen=str.length;
	var startType=typeof start,
	    endType=typeof end;

	if(startType!=="number" && endType!=="number")
	  return (isUpper)?str.toUpperCase():str.toLowerCase();
	else if(startType==="number" && endType!=="number")
	  end=strLen;

	if(start<0) start=0;
	if(start>strLen-1) start=strLen-1;
	if(end<0) end+=strLen;
	if(end<=start) return;
	if(end>strLen) end=strLen;

	var arr=str.split("");
	if(isUpper){
	  for(var i=start;i<end;i++)
		arr[i]=arr[i].toUpperCase();
	}else{
	  for(var i=start;i<end;i++)
		arr[i]=arr[i].toLowerCase();
	}
	return arr.join("");
  };
  _.upperCase=function (str,start,end){
    return upperOrLowerCase(str,start,end,true);
  },
  _.lowerCase=function (str,start,end){
    return upperOrLowerCase(str,start,end,false);
  };
  /* random string */
  _.randomStr=function (length){
    var length=length||5;
	var arr=new Array(length);
	while(length--){
	  arr[length]=String.fromCharCode(Math.floor(Math.random()*95)+32);
	}
	return arr.join("");
  };

  /***** Math *****/
  /* if integer */
  _.isInteger=function (num){
    if(typeof num!=="number") return false;
	if(Math.trunc(num)===num) return true;
	return false;
  };
  /* mod */
  _.mod=function (a,b){
	if(a===0 || a===b) return 0;
    if(b===0 || !_.isInteger(a) || !_.isInteger(b)) return;
	var c=Math.trunc(a/b);
	return a-c*b;
  };
  /* if even */
  _.isEven=function (num){
	if(!_.isInteger(num)) return false;
	return _.mod(num,2)===0;
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

  /***** Other Stuff Related To Javascript *****/
  /* return exact type of variable */
  _.typeof=function (obj){
	if(obj && obj.constructor._name)
	  return obj.constructor._name;
	return Object.prototype.toString.call(obj).slice(8, -1);
  };
  /* is instance of a class or implements a interface*/
  _.instanceof=function (obj,Class){
	var objtype=typeof obj;
	if(objtype==="object" || objtype==="function"){
	  if(obj instanceof Class)
		return true;
	  if(obj && obj.constructor._interfaceName)
		for(var o=obj;o!==Object.prototype;o=o.super)
          if(o.constructor._interfaceName.indexOf(Class._name||Class.name)!==-1 || o.constructor._superClassName.indexOf(Class._name||Class.name)!==-1)
		return true;
	}
	else if(objtype!=="undefined" && new Object(obj) instanceof Class)
	  return true;

	return false;
  };
  /* bind 'this' to a certain object */
  _.bind=function (that,fn){
	return function (){
	  return fn.apply(that,arguments);
	};
  };
  /* sniff the environment to use certain function */
  _.sniffer=function (fnArr,argsArr,that){
	if(!argsArr) argsArr=[];
	for(var i=0,len=fnArr.length;i<len;i++){
	  try{
		fnArr[i].apply(that,argsArr);
	  }catch(e){
		continue;
	  }
	  return fnArr[i];
	}
  };

  /***** normal use *****/
  /* loop */
  _.loop=function (fn,N){
    N=N||1;
	for(var i=0;i<N;i++)
	  fn(i);
  };
  /* timer */
  _.Timer=_.class("Timer",{
	init: function (){
	  this._time=0;
	},
	_now:_.sniffer([
	  function (){
	    return Date.now();
	  },
	  function (){
	    return (new Date()).getTime();
	  },
	]),
	start: function (){
	  this._time=this._now();
	},
	end: function (){
	  var tmp=this._now()-this._time;
	  console.log(tmp+" ms");
	  return tmp;
	},
  });
  /* counter */
  _.Counter=_.class("Counter",{
	init: function (num){
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


  /********** EXPOSE TO THE GLOBAL **********/
  /* save previous _ */
  var previous_=root._,
      previousTools=root.Tools;
  // deal with conflict
  _.noConflict=function (all){
    root._=previous_;
	if(all)
	  root.Tools=previousTools;
	return _;
  };
  // exprot to the global,the exports in Node.js or the window in Browser
  if(typeof exports!=='undefined' && typeof module!=='undefined' && module.exports){
	exports=module.exports=_;
  }else{
    root.Tools=root._=_;
  } 
  // if use AMD
  if(typeof define==='function' && define.amd){
    define('mylib',[],function(){
      return _;
    });
  } 
})(this);
