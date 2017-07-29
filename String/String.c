/*
 *Description: string lib for C,all function return a new string and the original string wiil not be changed
 *Author: b2ns
 */

#include <stdio.h>
#include <malloc.h>

int isAlpha(char ch)
{
  return (ch>='A' && ch<='Z') || (ch>='a' && ch <='z');
}

int isNum(char ch)
{
  return (ch>='0' && ch<='9');
}

char* toUpper(char* str)
{
  int len=0;
  char* tmp=str;

  while(*str++) len++;
  char* result=(char*)malloc(sizeof(char)*(len+1));

  str=tmp;
  tmp=result;
  while(*str) *result++=*str++;
  *result='\0';

  result=tmp;
  while(*result)
  {
	if(isAlpha(*result))
	{
	  *result&=0xdf;
	}
	result++;
  }
  return tmp;
}

char* toLower(char* str)
{
  int len=0;
  char* tmp=str;

  while(*str++) len++;
  char* result=(char*)malloc(sizeof(char)*(len+1));

  str=tmp;
  tmp=result;
  while(*str) *result++=*str++;
  *result='\0';

  result=tmp;
  while(*result)
  {
	if(isAlpha(*result))
	{
	  *result|=0x20;
	}
	result++;
  }
  return tmp;
}

int str2int(char* str,int radix)
{
  int sum=0;
  int flag=0;
  radix=(radix>0)?radix:-radix;
  if(*str=='+' || (*str=='-' && (flag=1))) str++;

  switch(radix)
  {
	case 2:
	  {
		while(*str && (*str=='0' || *str=='1'))
		{
		  sum=(sum<<1)+(*str-'0');
		  str++;
		}

	  }break;
	case 8:
	  {
		while(*str && (*str>='0' && *str<='7'))
		{
		  sum=(sum<<3)+(*str-'0');
		  str++;
		}

	  }break;
	case 16:
	  {
		if(*str && *str=='0' && (*(str+1)=='x' || *(str+1)=='X')) str+=2;
		while(*str && (isNum(*str) || (((*str)|0x20)>='a' && ((*str)|0x20)<='f')))
		{
		  if(isNum(*str))
			sum=(sum<<4)+(*str-'0');
		  else
			sum=(sum<<4)+(*str|0x20)-'a'+10;
		  str++;
		}

	  }break;
	default:
	  {
		while(*str && isNum(*str))
		{
		  sum=sum*radix+(*str-'0');
		  str++;
		}

	  }break;
  }
  return (flag)?-sum:sum;
}

double str2double(char* str)
{
  double sum=0.0;
  int negflag=0;
  int dot=0;
  int dotflag=0;
  int exp=0;
  int expflag=0;
  int expnegflag=0;
  if(*str=='+' || (*str=='-' && (negflag=1))) str++;
  while(*str && (isNum(*str) || *str=='e' || *str=='E' || *str=='.' || *str=='+' || *str=='-'))
  {
	if(*str=='.')
	{
	  if(dotflag==0) dotflag=1;
	  else break;
	}
	else if(*str=='e' || *str=='E')
	{
	  if(expflag==0) expflag=1;
	  else break;
	}
	else
	{
	  if(expflag)
	  {
		if(*str=='+' || (*str=='-' && (expnegflag=1))) ;
		else exp=exp*10+(*str-'0');
	  }
	  else if(*str!='+' && *str!='-')
	  {
		sum=sum*10+(*str-'0');
		if(dotflag) dot++;
	  }
	  else break;
	}

	str++;
  }

  exp=(expnegflag)?-exp:exp;
  int e=exp-dot;
  if(e>0)
  {
	while(e--)
	{
	  sum*=10;
	}
  }
  else if(e<0)
  {
	while(e++)
	{
	  sum/=10;
	}
  }

  return (negflag)?-sum:sum;
}

int strLen(char* str)
{
  int i=0;
  while(*str++) i++;
  return i;
}

char* strReverse(char* str)
{
  int len=strLen(str);
  char* result=(char*)malloc(sizeof(char)*(len+1));
  result[len]='\0';
  int i,j;
  for(i=0,j=len-1;i<len;i++,j--)
  {
	result[i]=str[j];
  }

  return result;
}
char* strCat(char* str1,char* str2)
{
  int len1=strLen(str1);
  int len2=strLen(str2);
  char* str=(char*)malloc(sizeof(char)*(len1+len2+1));
  char* tmp=str;

  while(*str1)
  {
	*str++=*str1++;
  }
  while(*str2)
  {
	*str++=*str2++;
  }
  *str='\0';
  return tmp;
}

char* strCopy(char* str)
{
  int len=strLen(str);
  char* strc=(char*)malloc(sizeof(char)*(len+1));
  char* tmp=strc;
  while(*str)
  {
	*strc++=*str++;
  }
  return tmp;
}

int strCmp(char* str1,char* str2)
{
  while(*str1 && *str2)
  {
	if(*str1>*str2) return 1;
	if(*str1++<*str2++) return -1;
  }
  if(*str1) return 1;
  if(*str2) return -1;
  return 0;
}

int strFind(char* main,char* sub)//KMP algorithm
{
  int i,j;
  int* next=(int*)malloc(sizeof(int)*strLen(sub));

  next[0]=-1;
  for(i=-1,j=0;sub[j];)
  {
	if(i==-1 || sub[i]==sub[j])
	{
	  next[++j]=++i;
	  if(sub[j]==sub[i])
		next[j]=next[i];
	}
	else
	{
	  i=next[i];
	}
  }

  for(i=0,j=0;sub[j] && main[i];)
  {
	if(main[i]!=sub[j])
	{
	  if((j=next[j])<0)
	  {
		j=0;i++;
	  }
	}
	else
	{
	  j++;i++;
	}
  }

  free(next);

  if(!sub[j]) return i-j;
  return -1;

}

char* strReplace(char* main,char* tar,char* rep,char opt)//opt:'g' for global,'f' for first,'l' for last
{
  int mainlen=strLen(main);
  int tarlen=strLen(tar);
  if(!mainlen || !tarlen) return main;

  int replen=strLen(rep);
  int* findindex=(int*)malloc(sizeof(int)*mainlen);
  int find,lastfind;
  int i,j,k;
  for(i=0;i<mainlen;i++)
	findindex[i]=0;

  for(i=0,j=0;(find=strFind(main+i,tar))>=0;i+=find+tarlen)
  {
	if(opt=='l')
	{
	  lastfind=find+i;
	  j=1;
	}
	else
	{
	  findindex[find+i]=1;j++;
	  if(opt=='f') break;
	}
  }
  if(opt=='l') findindex[lastfind]=1;

  int size=mainlen+j*(replen-tarlen)+1;
  char* result=(char*)malloc(sizeof(char)*(size));
  result[size-1]='\0';
  for(i=0,j=0;i<mainlen;)
  {
	if(findindex[i])
	{
	  for(k=0;k<replen;k++)
	  {
		result[j++]=rep[k];
	  }
	  i+=tarlen;
	}
	else
	{
	  result[j++]=main[i++];
	}
  }

  free(findindex);

  return result;
}

char* strSub(char* str,int left,int right)
{
  int len=strLen(str);
  left=(left<0)?0:left;
  right=(right>=len)?len-1:right;
  if(left>right)
  {
	int tmp=left;
	left=right;
	right=tmp;
  }

  char* substring=(char*)malloc(sizeof(char)*(right-left+2));
  substring[right-left+1]='\0';
  int i,j;
  for(i=left,j=0;i<=right;i++,j++)
  {
	substring[j]=str[i];
  }

  return substring;
}

char** strSplit(char* str,char* pat)
{
  int strlen=strLen(str);
  int patlen=strLen(pat);
  if(!patlen || !strlen) return NULL;

  int* findindex=(int*)malloc(sizeof(int)*strlen);
  int find;
  int i,j,k;
  for(i=0;i<strlen;i++)
	findindex[i]=0;

  for(i=0;i<strlen && (find=strFind(str+i,pat))>=0;)
  {
	findindex[find+i]=1;
	i+=find+patlen;
  }

  int size=strlen/2+2;
  char** array=(char**)malloc(sizeof(char*)*size);
  for(i=0;i<size;i++)
	array[i]=NULL;

  for(i=0,j=0,k=0;i<strlen;)
  {
	if(findindex[i])
	{
	  if(k)
	  {
		array[j]=(char*)malloc(sizeof(char)*(k+1));
		array[j][k]='\0';
		j++;
		k=0;
	  }
	  i+=patlen;
	}
	else
	{
	  i++;
	  k++;
	}
  }
  if(k)
  {
	array[j]=(char*)malloc(sizeof(char)*(k+1));
	array[j][k]='\0';
  }

  for(i=0,j=0,k=0;i<strlen;)
  {
	if(findindex[i])
	{
	  i+=patlen;
	  if(k)
	  {
		j++;k=0;
	  }
	}
	else
	{
	  array[j][k++]=str[i++];
	}
  }

  free(findindex);

  return array;
}
/*
int main(void)
{
  char str[50]="235What Is Goning On?";

  printf("%d\n",isAlpha('z'));
  printf("%d\n",isNum('0'));
  puts(toUpper(str));
  puts(str);
  puts(toLower(str));

  printf("%d\n",str2int("01100.001",2));
  printf("%d\n",str2int("142857abcde",10));
  printf("%d\n",str2int("0x7fffffff",16));
  printf("%lf\n",str2double("-123456.7e-5"));
  printf("%lf\n",str2double("-.8E300"));

  printf("%d\n",strLen("abc"));
  printf("%s\n",strReverse("abcdefg"));
  printf("%s\n",strCat("abcxyz","defgq  wer"));
  printf("%s\n",strCopy("abcde fghijk"));
  printf("%d\n",strCmp("ab","abc"));
  printf("%d\n",strFind("ababaaaba","aaba"));
  printf("%s\n",strReplace("   a  b a a c      da     aa      ","  ","###",'g'));
  printf("%s\n",strReplace("abc.def.hijk.js",".",".min.",'l'));
  printf("%s\n",strSub("abcdefg",1,5));
  char** array=strSplit(" xxx a xx b cxx d  xxx   e  xxxxx  ","xx");
  while(*array)
  {
	puts(*array);
	array++;
  }


  getchar();
  return 0;
}
*/

/*
//查看二进制位
void foo(int num,int size,int j)
{
  if(size)
  {
  foo(num>>1,size-1,j+1);
  int n=num&1;
  printf("%d",n);
  if(j%4==0) printf(" ");
  }
}
void foobar(long long num,int size,int j)
{
  if(size)
  {
  foobar(num>>1,size-1,j+1);
  int n=num&1;
  printf("%d",n);
  if(j%4==0) printf(" ");
  }
}*/
