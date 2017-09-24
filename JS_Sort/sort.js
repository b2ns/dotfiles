/* 
*Description: add new sort method for Array in JavaScript
*Author: b2ns 
 */

(function (exports) {

  //default comparator
  var defCmp = function (a, b) {
    if (typeof a === "string" && typeof b === "string") {
      if (a.length > b.length) return 1;
      if (a.length < b.length) return -1;
    }

    if (a > b) return 1;
    if (a < b) return -1;
    return 0;
  };

  //swap function
  var swap = function (arr, i, j) {
    var tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  };

  //BucketSort
  var bucket = function (cmp) {
    var arr = this;
    var len = arr.length;

    for (var i = 0, max = min = arr[i++]; i < len; i++) {
      if (cmp(max, arr[i]) === -1) max = arr[i];
      if (cmp(min, arr[i]) === 1) min = arr[i];
    }

    var bucketLen = max - min + 1;
    var bucketArr = new Array(bucketLen);

    for (var i = 0; i < bucketLen; i++)
      bucketArr[i] = 0;

    for (var i = 0; i < len; i++)
      bucketArr[arr[i] - min]++;

    for (var i = 0, j = 0; i < bucketLen;) {
      if (bucketArr[i] != 0) {
        arr[j++] = i + min;
        bucketArr[i]--;
      }
      else {
        i++;
      }
    }
  };

  //BubbleSort
  var bubble = function (cmp) {
    var arr = this;
    var len = arr.length;
    var flag = true;

    for (var i = 0; i < len - 1 && flag; i++)
      for (var j = len - 1, flag = false; j > i; j--)
        if (cmp(arr[j - 1], arr[j]) === 1) {
          swap(arr, j - 1, j);
          flag = true;
        }
  };

  //SelectSort
  var select = function (cmp) {
    var arr = this;
    var len = arr.length;

    for (var i = 0; i < len - 1; swap(arr, mini, i), i++)
      for (var mini = i, j = i + 1; j < len; j++)
        if (cmp(arr[mini], arr[j]) === 1)
          mini = j;
  };

  //InsertSort
  var insert = function (cmp) {
    var arr = this;
    var len = arr.length;

    for (var i = 1; i < len; arr[j + 1] = tmp, i++)
      for (var tmp = arr[i], j = i - 1; j >= 0 && cmp(tmp, arr[j]) === -1; j--)
        arr[j + 1] = arr[j];
  };

  //ShellSort
  var shell = function (cmp) {
    var arr = this;
    var len = arr.length;
    var index = Math.floor(Math.log2(len));

    for (var k = Math.pow(2, index) - 1; k >= 1; k = Math.pow(2, --index) - 1) {
      for (var i = k; i < len; arr[j + k] = tmp, i++)
        for (var tmp = arr[i], j = i - k; j >= 0 && cmp(tmp, arr[j]) === -1; j -= k)
          arr[j + k] = arr[j];
    }
  };

  //HeapSort
  var heap = function (cmp) {
    var arr = this;
    var len = arr.length;

    var floatDown = function (i, size) {
      var tmp = arr[i];
      for (j = 2 * i + 1; j < size; i = j, j = 2 * i + 1) {
        if (j != size - 1 && cmp(arr[j], arr[j + 1]) === -1)
          j++;
        if (cmp(tmp, arr[j]) === -1)
          arr[i] = arr[j];
        else
          break;
      }
      arr[i] = tmp;
    };

    for (var i = Math.floor(len / 2) - 1; i >= 0; i--)
      floatDown(i, len);
    for (var i = len - 1; i > 0; i--) {
      swap(arr, 0, i);
      floatDown(0, i);
    }
  };

  //MergeSort
  var merge = function (cmp) {
    var arr = this;
    var len = arr.length;
    var tmparr = new Array(len);

    var merger = function (lstart, rstart, rend) {
      for (var i = lstart, j = rstart, k = lstart; i < rstart && j < rend;) {
        if (cmp(arr[i], arr[j]) === -1)
          tmparr[k++] = arr[i++];
        else
          tmparr[k++] = arr[j++];
      }
      while (i < rstart)
        tmparr[k++] = arr[i++];
      while (j < rend)
        tmparr[k++] = arr[j++];
      for (var i = lstart; i < rend; i++)
        arr[i] = tmparr[i];
    };

    for (var k = 1; k < len; k <<= 1)
      for (var i = 0; i < len;) {
        var lstart = i;
        var rstart = (i += k);
        var rend = (i += k);
        if (rstart >= len) {
          rstart = rend = len;
        } else if (rend > len) {
          rend = len;
        }
        merger(lstart, rstart, rend);
      }

    /* Recursion method
        var merger = function (left,right) {
          if(left<right){
            var mid=Math.floor((left+right)/2);
            merger(left,mid);
            merger(mid+1,right);
    
            for(var i=left,j=mid+1,k=left;i<=mid && j<=right;){
              if(cmp(arr[i],arr[j])===-1)
                tmparr[k++]=arr[i++];
              else
                tmparr[k++]=arr[j++];
            }
            while(i<=mid)
                tmparr[k++]=arr[i++];
            while(j<=right)
                tmparr[k++]=arr[j++];
            for(var i=left;i<=right;i++)
              arr[i]=tmparr[i];
            }
        };
        merger(0,len-1); 
        */

  };

  //QuickSort
  var quick = function (cmp) {
    var arr = this;
    var len = arr.length;

    var choicePivot = function (left, right) {
      var mid = Math.floor((left + right) / 2);
      if (cmp(arr[left], arr[right]) === 1) swap(arr, left, right);
      if (cmp(arr[left], arr[mid]) === 1) swap(arr, left, mid);
      if (cmp(arr[mid], arr[right]) === 1) swap(arr, mid, right);

      swap(arr, mid, right - 1);
      return arr[right - 1];
    };
    var sortPivot = function (left, right) {
      if (right - left >= 10) {
        var pivot = choicePivot(left, right);
        for (var i = left, j = right - 1; ;) {
          while (cmp(arr[++i], pivot) === -1);
          while (cmp(arr[--j], pivot) === 1);

          if (i > j) break;

          swap(arr, i, j);
        }
        swap(arr, i, right - 1);
        sortPivot(left, i - 1);
        sortPivot(i + 1, right);
      }
      else {
        for (var i = left + 1; i <= right; arr[j + 1] = tmp, i++)
          for (var tmp = arr[i], j = i - 1; j >= left && cmp(tmp, arr[j]) === -1; j--)
            arr[j + 1] = arr[j];
      }
    };

    sortPivot(0, len - 1);
  };

  //overwrite the sort method of Array's prototype
  exports.sortBy = function (cmp, method) {
    if (typeof cmp != "function") {
      method = cmp;
      cmp = defCmp;
    }

    switch (method) {
      case "bucket": bucket.call(this, cmp); break;
      case "bubble": bubble.call(this, cmp); break;
      case "select": select.call(this, cmp); break;
      case "insert": insert.call(this, cmp); break;
      case "shell": shell.call(this, cmp); break;
      case "heap": heap.call(this, cmp); break;
      case "merge": merge.call(this, cmp); break;
      case "quick":
      default: quick.call(this, cmp); break;
    }
  };

})(Array.prototype);
