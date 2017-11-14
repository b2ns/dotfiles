// Interface
var Fly=_.interface("Fly",["fly"]),
	Speak=_.interface("Speak",["speak"]);

// Class
var Animal=_.class("Animal",{
  init: function (name,age){
    this.name=name||"小丑";
	this.age=age||1;
  },
  eat: function (){
    console.log("eat");
  },
  shout: function (){
    console.log("shout");
  },
});
var Tiger=_.class("Tiger",{
  init: function (name,age){
    Animal.init.apply(this,arguments);
  },
  scare: function (){
    console.log("scary");
  },

}).extends(Animal);

var Dog=_.class("Dog",{
  init: function (name,age,host){
    Animal.init.call(this,name,age);
	this.host=host||"nobody";
  },
  shout: function (){
    console.log("wangwang!");
  },
}).extends(Animal,Tiger);

var FlyDog=_.class("FlyDog",{
  init: function (name,age,host){
    Dog.init.apply(this,arguments);
  },
  fly: function (){
    console.log("flying");
  },
}).extends(Dog).implements(Fly);


var FlySpeakDog=_.class("FlySpeakDog",{
  init: function (name,age,host){
    FlyDog.init.apply(this,arguments);
  },
  speak: function (){
    console.log("speaking");
  },
}).extends(FlyDog).implements(Speak);

console.log(new Animal());
console.log(new Dog);
console.log(new FlyDog());
console.log(new FlySpeakDog());

var a=new FlySpeakDog("Jack",2,"丁世鹏");
console.log(a);
console.log(_.typeof(a));
console.log(_.instanceof(a,FlySpeakDog));
console.log(_.instanceof(a,FlyDog));
console.log(_.instanceof(a,Dog));
console.log(_.instanceof(a,Animal));
console.log(_.instanceof(a,Speak));
console.log(_.instanceof(a,Fly));
console.log(_.instanceof(a,Tiger));
console.log(_.instanceof(a,Array));
