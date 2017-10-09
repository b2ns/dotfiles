# A set of basic data structures for JavaScript
### Note: everything are under the namespace 'ds'.
## HashTable
    var ht = new ds.HashTable();

    ht.length();
    ht.insert(key,val);
    ht.delete(key);
    ht.find(key);
    ht.forEach(function (val,key){
        console.log(key+":"+val);
    });
    ht.clear();
## Set
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
## Stack
