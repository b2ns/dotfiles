# Add new sort method for Array in JavaScript
## Usage:
1.insert this in html:

    <script src="sort.js"></script>

2.to sort a array:

    array.sortBy();

3.customize the comparator:

    array.sortBy(function (a,b){
      if(a<b) return 1;
      if(a>b) return -1;
      return 0;
    });

4.choose proper method to sort(the default method is quickSort):

    array.sortBy("bucket");
    array.sortBy("bubble");
    array.sortBy("select");
    array.sortBy("insert");
    array.sortBy("shell");
    array.sortBy("heap");
    array.sortBy("merge");
    array.sortBy("quick");

5.more usage:

    array.sortBy(function (a,b){
      if(a.age>b.age) return 1;
      if(a.age<b.age) return -1;
      return 0;
    },"heap");
