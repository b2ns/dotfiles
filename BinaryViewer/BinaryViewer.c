/*
 *Description: view the binary format of a file
 *Author: b2ns
 */

#include <stdio.h>

void char2hex(char ch)
{
  char hex1=0,hex2=0;
  hex2=ch&0x0f;
  ch>>=4;
  hex1=ch&0x0f;
  printf("%c%c",hex1=(hex1<10)?hex1+'0':hex1-10+'a',hex2=(hex2<10)?hex2+'0':hex2-10+'a');
}

void uint2hex(unsigned int num,int i)
{
  if(i)
  {
	uint2hex(num>>8,i-1);
	char ch=num&0xff;
	char2hex(ch);
  }

}

int main(int argc,char** argv)
{
  if(argc==2)
  {
	FILE* infile=fopen(*(argv+1),"rb");
	unsigned int row;
	int col,i;
	char ch;

	for(col=32,row=1;(fread(&ch,1,1,infile))>0;)
	{
	  if(col>=32)
	  {
		printf("\n");uint2hex((row-1)<<4,4);printf(": ");
		col=0;
		row++;
	  }

	  if(col>=16)
	  {
		if(ch<=31)
		  printf(".");
		else
		  printf("%c",ch);
		col++;
	  }
	  else
	  {
		char2hex(ch);printf(" ");
		col++;
		if(col>=16)
		{
		  fseek(infile,-16L,1L);
		  printf(" ");
		}
	  }
	}

	for(i=0;i<(16-col);i++)
	  printf("   ");
	printf(" ");

	if(col<=16)
	  fseek(infile,-(long)col,2L);
	while((fread(&ch,1,1,infile))>0)
	{
	  if(ch<=31)
		printf(".");
	  else
		printf("%c",ch);
	}

	printf("\n");
	fclose(infile);
  }
  else if(argc==1)
  {
	printf("need a file to view!\n");
  }
  else
  {
	printf("too many parameters!\n");
  }

  return 0;
}
