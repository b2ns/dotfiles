/*
 *Description: minimize html, css, js, json and other similar files
 *Author: b2ns
 */

#include <stdio.h>
#include <stdlib.h>

#include "../String/String.c"

//define func pointer
typedef int (*FACTORYOUT)(char);

//global
char* inname;
char* outname;
char* postfix;
FILE* infile;
FILE* outfile;

int quoteFlag=0;
int commentFlag=0;

//file operation
void getFileName(char* filename)
{
  char** arr=strSplit(filename,".");
  if(!arr[1])
  {
	printf("need postfix .html,.css,.js,.json in filename to distinguish the file !\n");
	exit(-1);
  }

  inname=filename;

  char** tmp=arr;
  while(*(arr+1)) arr++;
  postfix=*arr;

  outname=strReplace(inname,".",".min.",'l');

  free(tmp);
}

void openFile()
{
  infile=fopen(inname,"rb");
  if(!infile)
  {
	printf("no such file named: %s !\n",inname);
	exit(-1);
  }
  outfile=fopen(outname,"wb");
}

void closeFile()
{
  fclose(infile);
  fclose(outfile);
}

char preNextChar(int n)
{
  long cur=ftell(infile);
  if(cur<=(-n)) return 'x';
  n=(long)n;
  long m=n-1;

  fseek(infile,m,1L);
  char ch=fgetc(infile);
  fseek(infile,-n,1L);
  return ch;
}

//check if it is name, quote, comment
int htmlName(char ch)
{
  return (ch!=' '&& ch!='>');
}
int cssName(char ch)
{
  return ((ch>='a'&&ch<='z')||(ch>='A'&&ch<='Z')||(ch>='0'&&ch<='9')||(ch=='$')||(ch=='_')||(ch=='#')||(ch=='.')||(ch=='+')||(ch=='-')||(ch=='%')||(ch=='*'));
}
int name(char ch)
{
  return ((ch>='a'&&ch<='z')||(ch>='A'&&ch<='Z')||(ch>='0'&&ch<='9')||(ch=='$')||(ch=='_'));
}

int htmlQuote(char ch)
{
  char tmp;
  /*static int quoteFlag=0;*/
  if(ch=='\"' && preNextChar(-1)!='\\')
  {
	if(quoteFlag==0) quoteFlag=1;
	else if(quoteFlag==1) quoteFlag=0;
  }
  else if(ch=='\'' && preNextChar(-1)!='\\')
  {
	if(quoteFlag==0) quoteFlag=2;
	else if(quoteFlag==2) quoteFlag=0;
  }
  else if(ch=='<' && ((tmp=preNextChar(1))=='p' || tmp=='/') && ((tmp=preNextChar(2))=='r' || tmp=='p') && ((tmp=preNextChar(3))=='e' || tmp=='r') && ((tmp=preNextChar(4))=='>' || (tmp=='e' && preNextChar(5)=='>')))
  {
	if(quoteFlag==0) quoteFlag=3;
	else if(quoteFlag==3) quoteFlag=0;
  }

  return quoteFlag;
}
int jsonQuote(char ch)
{
  if(ch=='\"' && preNextChar(-1)!='\\')
  {
	if(quoteFlag==0) quoteFlag=1;
	else if(quoteFlag==1) quoteFlag=0;
  }
  else if(ch=='\'' && preNextChar(-1)!='\\')
  {
	fputc('\\',outfile);
  }

  return quoteFlag;
}
int quote(char ch)
{
  /*static int quoteFlag=0;*/
  if(ch=='\"' && preNextChar(-1)!='\\')
  {
	if(quoteFlag==0) quoteFlag=1;
	else if(quoteFlag==1) quoteFlag=0;
  }
  else if(ch=='\'' && preNextChar(-1)!='\\')
  {
	if(quoteFlag==0) quoteFlag=2;
	else if(quoteFlag==2) quoteFlag=0;
  }

  return quoteFlag;
}

int htmlComment(char ch)
{
  /*static int commentFlag=0;*/
  if(ch=='/' && preNextChar(1)=='*' && commentFlag==0)
	commentFlag=1;
  else if(preNextChar(-1)=='/' && preNextChar(-2)=='*' && preNextChar(-3)!='/' && commentFlag==1)
	commentFlag=0;
  else if(ch=='/' && preNextChar(1)=='/' && commentFlag==0)
	commentFlag=2;
  else if(preNextChar(-1)=='\n' && commentFlag==2)
	commentFlag=0;
  else if(ch=='<' && preNextChar(1)=='!' && preNextChar(2)=='-' && preNextChar(3)=='-' && commentFlag==0)
	commentFlag=3;
  else if(preNextChar(-3)=='-' && preNextChar(-2)=='-' && preNextChar(-1)=='>' && commentFlag==3)
	commentFlag=0;

  return commentFlag;


}
int comment(char ch)  // /*this is not a right form "*/" for comment*/
{
  /*static int commentFlag=0;*/
  if(ch=='/' && preNextChar(1)=='*' && commentFlag==0)
	commentFlag=1;
  else if(preNextChar(-2)=='*' && preNextChar(-1)=='/' && commentFlag==1)
	commentFlag=0;
  else if(ch=='/' && preNextChar(1)=='/' && commentFlag==0)
	commentFlag=2;
  else if(preNextChar(-1)=='\n' && commentFlag==2)
	commentFlag=0;

  return commentFlag;
}


//factory func
FACTORYOUT* funcFactory()
{
  FACTORYOUT* arr=(FACTORYOUT*)malloc(sizeof(FACTORYOUT)*3);
  if(!strCmp("html",toLower(postfix)))
  {
	arr[0]=htmlName;
	arr[1]=htmlQuote;
	arr[2]=htmlComment;
  }
  else
  {
	arr[0]=(!strCmp("css",toLower(postfix)))?cssName:name;
	arr[1]=(!strCmp("json",toLower(postfix)))?jsonQuote:quote;
	arr[2]=comment;
  }

  return arr;
}


//minimize
void minimize()
{
  FACTORYOUT* arr=funcFactory();
  FACTORYOUT isName=arr[0];
  FACTORYOUT isInQuote=arr[1];
  FACTORYOUT isInComment=arr[2];
  char ch,nonspace;

  while((ch=fgetc(infile))!=EOF)
  {
	if((!commentFlag) && isInQuote(ch))
	{
	  fputc(ch,outfile);
	}
	else
	{
	  if(isInComment(ch) || ch=='\n' || ch=='	') continue;
	  if(ch!=' ') nonspace=ch;
	  else if((!isName(preNextChar(1)) || !isName(nonspace))) continue;

	  fputc(ch,outfile);
	}
  }
}


int main(int argc,char** argv)
{
  if(argc>=2)
  {
	int i;
	for(i=1;i<argc;i++)
	{
	  getFileName(argv[i]);

	  openFile();

	  minimize();

	  closeFile();
	}

  }
  else
  {
	printf("need files to minimize or maximize !\n");
	exit(-1);
  }

  printf("done !\n");
  return 0;
}
