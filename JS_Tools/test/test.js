var Shop=_.class("Shop",{
  abstract: ["sell"],
});

var FruitShop=_.class("FruitShop",{
  init: function (host){
    this.host=host||"nobody";
	this.log=host+"'s fruit shop";
  },
  sell: function (fruit,num){
	this._welcome();
    var fruit;
	switch(fruit){
	  case "apple": fruit=new Apple(); break;
	  case "banana": fruit=new Banana(); break;
	  default: console.log("no such fruit here!"); return;
	}
	fruit.wash();
	this._goodbye(this._account(fruit,num));
  },
  _welcome: function (phrase){
	console.log(phrase||"welocm to "+this.log);
  },
  _goodbye: function (account){
	console.log("total: $"+account);
    console.log("thanks for buying!");
  },
  _account: function (fruit,num){
	return fruit.onSale(fruit.price*num);
  },
}).extends(Shop);

var Fruit=_.class("Fruit",{
  init: function (price,isonsale){
	this.name=this.constructor._name;
    this.price=price||0;
	this.isonsale=isonsale;
  },
  wash: function (){
    console.log("washing "+this.name.toLowerCase()+" ...");
  },
  abstract: ["onSale"],
});
var Apple=_.class("Apple",{
  init: function (){
	Fruit.init.call(this,10,true);
  },
  onSale: function (total){
	if(!this.isonsale) return total;
	return total*0.5;
  },
}).extends(Fruit);

// instance
var myshop=new FruitShop("dsp");
myshop.sell("apple",100);
console.log(new Apple());
console.log(new Apple().__methods());
console.log(new Apple().__type());
var a=new Apple();
console.log(a.__attributes());
console.log(new _.Timer().__methods());
