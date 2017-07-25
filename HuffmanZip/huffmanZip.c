/*
 *Description: compress and uncompress file based on huffman algorithm
 *Author: b2ns
 */

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>

//inti size of PriorityQueue
#define SIZE 50

//huffmanTree struct
typedef struct huffNode* Pos;
typedef struct huffNode
{
  int frq;
  char ch;
  char code;
  Pos parent;
  Pos left;
  Pos right;
}huffNode;

//PriorityQueue struct
typedef huffNode* eleType;
typedef struct binaryHeap
{
  int size;
  int count;
  eleType* array;
}binaryHeap;
typedef struct binaryHeap* PriorityQueue;

//PriorityQueue function declaration
PriorityQueue newPriorityQueue();
int isEmpty(PriorityQueue PQ);
void Resize(PriorityQueue PQ);
void Insert(PriorityQueue PQ,eleType ele);
eleType deleteMin(PriorityQueue PQ);
void freeThePriorityQueue(PriorityQueue PQ);


//encode and decode function declaration
int frqarr[256]={0};
void decode(FILE* infile,long END,FILE* outfile);
void encode(FILE* infile,long END,FILE* outfile);
void freeTheHuffmanTree(huffNode* T)
{
  if(T)
  {
	freeTheHuffmanTree(T->left);
	freeTheHuffmanTree(T->right);
	free(T);
  }
}


int main(int argc,char **argv)
{
  if(argc==4 && argv[1][0]=='-' && argv[1][1]=='x')
  {
	char* inname=argv[2];
	char* outname=argv[3];
	FILE* infile=fopen(inname,"rb");
	FILE* outfile=fopen(outname,"wb");
	long END;
	fseek(infile,0L,2L);
	END=ftell(infile);
	rewind(infile);

	decode(infile,END,outfile);

	fclose(infile);
	fclose(outfile);
  }
  else if(argc==3)
  {
	char* inname=argv[1];
	char* outname=argv[2];
	FILE* infile=fopen(inname,"rb");
	FILE* outfile=fopen(outname,"wb");
	long END;
	fseek(infile,0L,2L);
	END=ftell(infile);
	rewind(infile);

	encode(infile,END,outfile);

	fclose(infile);
	fclose(outfile);
  }
  else
  {
	printf("to encode: huffman originalFile compressedFile\n");
	printf("to decode: huffman -x compressedFile originalFile\n");
	exit(-1);
  }

  /*getchar();*/
  return 0;
}


//PriorityQueue function defination
PriorityQueue newPriorityQueue()
{
  PriorityQueue pq=(PriorityQueue)malloc(sizeof(binaryHeap));
  pq->size=SIZE;
  pq->count=0;
  pq->array=(eleType*)malloc(sizeof(eleType)*pq->size);
  return pq;
}
int isEmpty(PriorityQueue PQ)
{
  return PQ->count==0;
}
void Resize(PriorityQueue PQ)
{
  if(PQ->count>=PQ->size-1)
	PQ->size*=2;
  else if(PQ->size/2>=SIZE && PQ->count<PQ->size/4)
	PQ->size/=2;
  else return;

  eleType* oldarry=PQ->array;
  PQ->array=(eleType*)malloc(sizeof(eleType)*PQ->size);
  int i;
  for(i=1;i<=PQ->count;i++)
	PQ->array[i]=oldarry[i];
  free(oldarry);
}
void Insert(PriorityQueue PQ,eleType ele)
{
  eleType* array=PQ->array;
  int insert=++PQ->count;
  int child;
  int parent;
  for(child=insert,parent=child/2;parent>0 && ele->frq<array[parent]->frq;child=parent,parent/=2)
	array[child]=array[parent];
  array[child]=ele;

  Resize(PQ);
}
eleType deleteMin(PriorityQueue PQ)
{
  /*if(!PQ->count) return -1;*/
  eleType* array=PQ->array;
  eleType minele=array[1];
  eleType lastele=array[PQ->count--];
  int i,j;
  for(i=1;2*i<=PQ->count && ((j=(array[2*i]->frq<array[2*i+1]->frq)?2*i:2*i+1) && !(lastele->frq<=array[j]->frq));i=j)
	array[i]=array[j];
  array[i]=lastele;

  Resize(PQ);

  return minele;
}
void freeThePriorityQueue(PriorityQueue PQ)
{
  free(PQ->array);
  free(PQ);
}

//decode defination
void decode(FILE* infile,long END,FILE* outfile)
{
  int countletter;
  int seqsize;
  fscanf(infile,"%d%d",&countletter,&seqsize);
  /*printf("%d:%d\n",countletter,seqsize);*/

  int i;
  char ch;
  int frq;
  PriorityQueue pq=newPriorityQueue();

  //make HuffmanTree
  huffNode* HuffmanTree;
  for(i=0;i<countletter;i++)
  {
	fgetc(infile);
	fscanf(infile,"%c%d",&ch,&frq);
	/*printf("%c&%d\n",ch,frq);*/
	huffNode* tmp=(huffNode*)malloc(sizeof(huffNode));
	tmp->frq=frq;
	tmp->ch=ch;
	tmp->left=NULL;
	tmp->right=NULL;
	Insert(pq,tmp);
  }

  while(!isEmpty(pq))
  {
	huffNode* p1=deleteMin(pq);
	/*printf("%c_%d\n",p1->ch,p1->frq);*/
	if(!isEmpty(pq))
	{
	  huffNode* p2=deleteMin(pq);
	/*printf("%c_%d\n",p2->ch,p2->frq);*/
	  huffNode* newroot=(huffNode*)malloc(sizeof(huffNode));
	  newroot->frq=p1->frq+p2->frq;
	  newroot->ch=0;
	  newroot->left=p1;
	  newroot->right=p2;
	  Insert(pq,newroot);
	}
	else
	{
	  HuffmanTree=p1;
	}
  }
  //output the file
  huffNode* p=HuffmanTree;
  int count=0;
  fgetc(infile);
  for(i=0;i<END;i++)
  {
	ch=fgetc(infile);
	int k;
	for(k=0;k<8;k++,ch<<=1)
	{
	  /*printf("\n%d\n",count);*/
   if(count>=seqsize) break;
	 char n=ch & 128;
	 if(n==0)
	   p=p->left;
	 else
	   p=p->right;
	 if(p->left==NULL || p->right==NULL)
	 {
	   fputc(p->ch,outfile);
	   p=HuffmanTree;
	 }
	 count++;
	}
  }

  freeThePriorityQueue(pq);
}

//encode defination
void encode(FILE* infile,long END,FILE* outfile)
{
  char ch;
  int filesize=100;
  int filelength;
  int countletter=0;
  int i,j;

  char *file=(char*)malloc(sizeof(char)*filesize);
  PriorityQueue pq=newPriorityQueue();

  huffNode* HuffmanTree;
  huffNode* HuffmanNode[256]={0};

  char* alpha[256]={0};
  int seqsize=0;

  //read data
  for(i=0;i<END;i++)
  {
	ch=fgetc(infile);
	frqarr[(unsigned char)ch]++;
	file[i]=ch;
	if(i>=filesize-1)
	{
	  char *oldfile=file;
	  file=(char*)malloc(sizeof(char)*filesize*2);
	  int j;
	  for(j=0;j<filesize;j++)
		file[j]=oldfile[j];
	  filesize*=2;
	  free(oldfile);
	}
  }
  //get data length
  filelength=i;

  //make HuffmanTree
  for(i=0;i<256;i++)
	if(frqarr[i])
	{
	  countletter++;

	  huffNode* pnode=(huffNode*)malloc(sizeof(huffNode));
	  pnode->frq=frqarr[i];
	  pnode->ch=i;
	  pnode->parent=NULL;
	  pnode->left=NULL;
	  pnode->right=NULL;
	  Insert(pq,pnode);
	  HuffmanNode[i]=pnode;
	}
  while(!isEmpty(pq))
  {
	huffNode* p1=deleteMin(pq);
	if(!isEmpty(pq))
	{
	  huffNode* p2=deleteMin(pq);
	  huffNode* newroot=(huffNode*)malloc(sizeof(huffNode));
	  newroot->frq=p1->frq+p2->frq;
	  newroot->parent=NULL;
	  newroot->left=p1;
	  newroot->right=p2;

	  p1->code='0';
	  p1->parent=newroot;
	  p2->code='1';
	  p2->parent=newroot;
	  Insert(pq,newroot);
	}
	else
	{
	  HuffmanTree=p1;
	}
  }
  //free PriorityQueue
  freeThePriorityQueue(pq);

  //make the alpha code list
  for(i=0;i<256;i++)
  {
	if(frqarr[i])
	{
	  huffNode* tmp=HuffmanNode[i];
	  int j;
	  for(j=0;tmp && tmp->parent;tmp=tmp->parent,j++) ;

	  alpha[i]=(char*)malloc(j+1);
	  seqsize+=frqarr[i]*j;

	  alpha[i][j]='\0';
	  int k;
	  for(k=j-1,tmp=HuffmanNode[i];tmp && tmp->parent;tmp=tmp->parent,k--)
	  {
		alpha[i][k]=tmp->code;
	  }
	}
  }

  //free HuffmanTree
  freeTheHuffmanTree(HuffmanTree);
  
  //output the compresssed file
  fprintf(outfile,"%d ",countletter);
  fprintf(outfile,"%d ",seqsize);

  for(i=0;i<256;i++)
  {
	if(frqarr[i])
	{
	  fprintf(outfile,"%c%d ",i,frqarr[i]);
	}
  }

  char out=0;
  for(i=0,j=0;i<filelength;i++)
  {
	int k=0;
	while((ch=alpha[(unsigned char)file[i]][k++])!='\0')
	{
	  out=(out<<1)+(ch-'0');j++;
	  if(j>=8)
	  {
		fputc(out,outfile);
		out=0;
		j=0;
	  }
	}
  }

  int res=8-seqsize%8;
  for(i=0;i<res;i++)
	out<<=1;
  fputc(out,outfile);

  //free memory
  free(file);
  for(i=0;i<256;i++)
	free(alpha[i]);
}
