/*
 *Description: minimize html, css, js and json files
 *Author: b2ns
 */

#include <stdio.h>
#include <stdlib.h>

#include "../String/String.c"


void getFileName(char* filename,char** inname,char** outname,char** postfix)
{
  char** arr=strSplit(filename,".");
  if(!arr[1])
  {
	printf("need postfix *.html,*.css,*.js,*.json in filename to distinguish the file !\n");
	exit(-1);
  }
  if(arr[2])
  {
	printf("too much point in filename !\n");
	exit(-1);
  }

  *inname=filename;
  *postfix=arr[1];
  char* tmp=strCat(arr[0],".min.");
  *outname=strCat(tmp,arr[1]);

  free(tmp);
  free(arr);
}

void openFile(char* inname,char* outname,FILE** infile,FILE** outfile)
{
  *infile=fopen(inname,"rb");
  if(!*infile)
  {
	printf("no such file !\n");
	exit(-1);
  }
  *outfile=fopen(outname,"wb");
}

void closeFile(FILE* infile,FILE* outfile)
{
  fclose(infile);
  fclose(outfile);
}

int isName(char ch)
{
  return ((ch>='a'&&ch<='z')||(ch>='A'&&ch<='Z')||(ch>='0'&&ch<='9')||(ch=='$')||(ch=='_'));
}

void html(FILE* infile,FILE* outfile)
{

}







int main(int argc,char** argv)
{
  if(argc>=2)
  {
	int i;
	char* postfix;
	char* inname;
	char* outname;
	FILE* infile;
	FILE* outfile;

	for(i=1;i<argc;i++)
	{
	  getFileName(argv[i],&inname,&outname,&postfix);
	  puts(inname);
	  puts(outname);
	  puts(postfix);

	  openFile(inname,outname,&infile,&outfile);
	  if(!strCmp("html",toLower(postfix)))
		html(infile,outfile);
	  else if(!strCmp("css",toLower(postfix)))
		html(infile,outfile);
	  else if(!strCmp("js",toLower(postfix)))
		html(infile,outfile);
	  else if(!strCmp("json",toLower(postfix)))
		html(infile,outfile);
	  else
	  {
		printf("only support standard html, css, js and json file !\n");
		remove(outname);
		exit(-1);
	  }

	  closeFile(infile,outfile);
	}

  }
  else
  {
	printf("need files to minimize !\n");
	exit(-1);
  }

  printf("done !\n");
  return 0;
}
