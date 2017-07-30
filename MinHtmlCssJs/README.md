# Minimize html, css, js, json and other similar files
## Usage
type this in terminal

    MinHtmlCssJs file1.html file2.css file3.js file4.json
will generate these:
    
    file1.min.html, file2.min.css, file3.min.js, file4.min.json

## Demonstration
1.html

befoe:

    <!DOCTYPE  html >

    <!-- you can't see me  -->
    <html lang = "en">
    <head>
      <meta charset="utf-8">
      <title>MinHtmlCssJs     </title>
      <meta name="description" content="space       will not be deleted !  that's what I want !"                     >
      <meta  name='keywords' content=' "minimize" '>
    </head>
    <body>
      <p class="button playing hide"   >  L    o   r    e   m   </p>
      <pre> this  will   not  be  
      minimized !  </pre>
    </body>
    </html>
after:
    
    <!DOCTYPE html><html lang = "en"><head><meta charset="utf-8"><title>MinHtmlCssJs </title><meta name="description" content="space       will not be deleted !  that's what I want !"><meta name='keywords' content=' "minimize" '></head><body><p class="button playing hide">L o r e m </p><pre> this  will   not  be  
      minimized !  </pre></body></html>
2.css

before:

    .container  >  #main  p :: before {
      content='cascading   "style"  sheet' ;
      /* you can't see me */
      display : none;
      margin: 20px   -50px   10px 0   ;
      opacity:    0
    }
    #nav    ul   {
      list-style: none
    }
after:

    .container>#main p::before{content='cascading   "style"  sheet';display:none;margin:20px -50px 10px 0;opacity:0}#nav ul{list-style:none}
3.javacript

before:

    var a=142857;//you can't see me
    var foo = function bar(  ) {
      /*you
        can't
        see
        me
       */
       var b = a + 100 * 50  +"I'm" +"I\'m" + 'quote""' + ' \n '  ;
       for  (var  i= 0; i < 100 ; i++ ){
         console.log(b);
       }
    };
after:

    var a=142857;var foo=function bar(){var b=a+100*50+"I'm"+"I\'m"+'quote""'+' \n ';for(var i=0;i<100;i++){console.log(b);}};
4.json

before:

    {
      "name"  :  "min' html' css' js "  ,
      "array": [ 1 , "one" ,2,  3]  ,

      "obj" :  {
        "name":  "Dovahkiin"  ,
        "age" :   1  ,
        "quote":  "I used to be an adventurer like you, then I took an arrow in the knee. "
      } 
    }
after:

    {"name":"min\' html\' css\' js ","array":[1,"one",2,3],"obj":{"name":"Dovahkiin","age":1,"quote":"I used to be an adventurer like you, then I took an arrow in the knee. "}}