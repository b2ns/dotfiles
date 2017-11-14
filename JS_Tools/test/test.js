// Interface
var Live=_.interface("Live",["eat",12,"sleep"]);
var Walk=_.interface("Walk",["walk"]);

// Class
var Man=_.class("Man",{
  _init: function (){
	this.name="Man";
  },
  getName: function (){
	console.log(this.name);
    return this.name
  },
  sleep:function (){

  },
   
}).extends();

var Fly=_.class("Fly",{
  foo: function (){
    console.log("foo from fly");
  },
  _run: function (){
    console.log("run");
  },
  fly: function (){
	this._run();
    console.log("fly");
  },
});

var Swim=_.class("Swim",{
  foo: function (){
    console.log("foo from swim");
  },
  _breath: function (){
    
  },
  swim: function (){
    console.log("swim");
  },
});

var Boy=_.class("Boy",{
  _init: function (name,age){
	this._super._init.call(this,name);
    this.age=age||12;
  },
  getAge: function (){
    console.log(this.age);
	return this.age
  },
  eat:function (){
    
  },
  walk:function (){
    
  },
}).extends(Man,12,Fly,Swim).implements(Live,12,Walk);

console.log(new Boy());
var b=new Boy();
console.log(_.typeof(b));
