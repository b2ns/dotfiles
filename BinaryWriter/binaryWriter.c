/*
 *Description: write a file into another
 *Author: b2ns
 */

#include <stdio.h>
#include "../String/String.c"

int main(int argc,char** argv)
{
  if(argc==4)
  {
	char* inname=argv[1];
	char* outname=argv[3];
	int startIndex=str2int(argv[2],16)-1;

	FILE* infile=fopen(inname,"rb");
	FILE* outfile=fopen(outname,"rb+");
	fseek(outfile,(long)startIndex,0L);

	char ch;
	
	while((fread(&ch,1L,1L,infile))>0)
	{
	  fwrite(&ch,1L,1L,outfile);
	}

	fclose(infile);
	fclose(outfile);

	printf("done!\n");
	return 0;
  }
  else
  {
	printf("Usage:\n");
	printf("binaryWriter infile startIndex(hex) outfile\n");
	return -1;
  }
}
