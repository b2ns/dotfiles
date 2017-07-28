# overwrite the default sort method of Array's prototype
## usage:
1.insert this in html:

    <script src="sort.js"></script>

2.to sort a array:

    array.sort();

3.customize the comparator:

    array.sort(function (a,b){
      if(a<b) return 1;
      if(a>b) return -1;
      return 0;
    });

4.choose proper method to sort(the default method is quickSort):

    array.sort("bucket");
    array.sort("bubble");
    array.sort("select");
    array.sort("insert");
    array.sort("shell");
    array.sort("heap");
    array.sort("merge");
    array.sort("quick");

5.more usage:

    array.sort(function (a,b){
      if(a.age>b.age) return 1;
      if(a.age<b.age) return -1;
      return 0;
    },"heap");
