# A set of basic data structures for JavaScript
### Note: everything is under the namespace **ds**.
___
## HashTable
___
```
var ht = new ds.HashTable();

ht.length();
ht.insert(key,val);
ht.delete(key);
ht.find(key);
ht.forEach(function (val,key){
console.log(key+":"+val);
});
ht.clear();
```
## Set
___
```
var set1 = new ds.Set(),
        set2 = new ds.Set();
    
set1.length();
set1.insert(val);
set1.delete(val);
set1.find(val);
set1.forEach(function (val){
        console.log(val);
    });
set1.intersect(set2);
set1.union(set2);
set1.complement(set2);
set1.clear();
```
## Stack
___
```
var  s = new ds.Stack();

s.length();
s.push(val);
s.pop();
s.top();
s.bottom();
s.clear();
```
## Queue
___
```
var q = new ds.Queue();

q.length();
q.enqueue(val);
q.dequeue();
q.first();
q.last();
q.clear();
```
## List
___
```
var lst = new ds.List();
var lst = new ds.List(function (a,b){
        return (a.id === b.id) ? 0 : 1;
    });

lst.length();
lst.insert(val); or lst.insert(val,existVal);
lst.delete(val);
lst.find(val);
lst.forEach(function (val){
        console.log(val);
    });
lst.clear();
```
## BinarySearchTree(AVL)
___
```
var bst = new ds.BST();
var bst = new ds.BST(function (a,b){
        return (a.id > b.id) ? 1 : ((a.id < b.id) ? -1 : 0);
    });

bst.length();
bst.insert(val);
bst.delete(val);
bst.find(val);
bst.min();
bst.max();
bst.forEachPre(function (val){
        console.log(val);
    });
bst.forEachMid(function (val){
        console.log(val);
    });
bst.forEachPost(function (val){
        console.log(val);
    });
bst.forEachLevel(function (val){
        console.log(val);
    });
bst.clear();
```
## PriorityQueue
___
```
var pq = new ds.PQ();
var pq = new ds.PQ(function (a,b){
        return (a.id > b.id) ? 1 : ((a.id < b.id) ? -1 : 0);
    });

pq.length();
pq.insert(val);
pq.delete();
pq.top();
pq.forEach(function (val){
        console.log(val);
    });
pq.clear();
```
    
