/*
 *Description: write binary(hex) into a file instead of ascii
 *Authour: b2ns
 */

#include <stdio.h>

int isNum(char ch)
{
  return (ch>='0' && ch<='9');
}
int isAF(char ch)
{
  return (ch>='a' && ch<='f')||(ch>='A' && ch<='F');
}

int main(int argc,char** argv)
{
  if(argc==2)
  {
	char* name=argv[1];
	FILE* file;
	if(!(file=fopen(name,"rb+")))
	  file=fopen(name,"wb+");
	else
	  fseek(file,0L,2L);

	printf("Enter '#' to exit !\n");
	char ch1,ch2;
	char sum=0;
	while((ch1=getchar())!='#')
	{
	  if(isNum(ch1)||isAF(ch1))
	  {
		ch2=getchar();
		if(isNum(ch2)||isAF(ch2))
		{
		  ch1=(isNum(ch1))?ch1-'0':(ch1|0x20)-'a'+10;
		  ch2=(isNum(ch2))?ch2-'0':(ch2|0x20)-'a'+10;
		  sum=ch1;
		  sum<<=4;
		  sum+=ch2;
		  fwrite(&sum,1L,1L,file);
		}
		else if(ch2=='#')
		  break;
	  }
	}

	printf("done!\n");
	return 0;
  }
  else
  {
	printf("need a filename!\n");
	return -1;
  }
}
