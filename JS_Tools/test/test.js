// Interface
var Fly=_.interface("Fly",["run","fly"]);
var Swim=_.interface("Swim",[]);
var Jump=_.interface("Jump",["jump"]);

// Class
var Human=_.class("Human",{
  init:function (name,age,sex){
    this.name=name||"name";
	this.age=age||20;
	this.sex=sex||"male";
  },
  speak: function (){
    console.log("speak");
  },
  walk: function (){
    console.log("walk");
  },
  run: function (){
    console.log("run");
  },
  foo: function (){
    console.log("foo from Man");
  },
});
var Alien=_.class("Alien",{
  init: function (force){
    this.force=force||100;
  },
  transform: function (){
    console.log("transform");
  },
  foo: function (){
    console.log("foo from Alien");
  },
});

var SuperMan=_.class("SuperMan",{
  init: function (name,age,sex,height,force){
	Human.init.apply(this,arguments);
	Alien.init.call(this,force);
	this.height=height||173;

  },
  lazer: function (){
    console.log("lazer");
	this.foo();
	this.super.foo();
  },
  fly: function (){
    console.log("fly");
  },
  foo: function (){
    console.log("foo from SuperMan");
  },
}).extends(Human,Alien).implements(Fly,Swim);


// Instance
var sm=new SuperMan("Clark",30,"male",188);
console.log(sm);
console.log(sm.methods());
console.log(_.instanceof(23,Number));
console.log(_.instanceof(null,Object));
console.log(_.instanceof(undefined,Object));
console.log(_.instanceof(sm,Human));
console.log(_.instanceof(sm,Object));
console.log(_.instanceof(sm,Alien));
console.log(_.instanceof(sm,Fly));

console.log(_.typeof(undefined));
console.log(_.typeof(null));
console.log(_.typeof(0));
console.log(_.typeof(""));
