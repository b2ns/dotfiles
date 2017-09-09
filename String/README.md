# Use String lib without side effect in C
## Usage:
    
    isAlpha('z');
    isNum('0');
    toUpper("abCde");
    toLower(ABcDE);

    str2int("01100.001",2);
    str2int("142857abcde",10);
    str2int("0x7fffffff",16);

    str2double("-123456.7e-5");
    str2double("-.8E300");

    strLen("abc");

    strReverse("abcdefg");

    strCat("abcxyz","defgq  wer");

    strCopy("abcde fghijk");

    strCmp("ab","abc");

    strFind("ababaaaba","aaba");

    strReplace("   a  b a a c      da     aa      ","  ","###",'g');  //global:replace all matched
    strReplace("abc.def.hijk.js",".",".min.",'f');  //first:replace the first matched
    strReplace("abc.def.hijk.js",".",".min.",'l');  //last:replace the last matched

    strSub("abcdefg",1,5);

    char** array=strSplit(" xxx a xx b cxx d  xxx   e  xxxxx  ","xx");
