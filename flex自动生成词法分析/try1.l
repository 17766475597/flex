%{
      int line=1,i=0,j;
      bool flag=false;
      char *textv[30];
      typedef struct{int linev;int typev}Sep;
      Sep word[30];
%}
DIGIT [0-9]
PINTEGER [1-9]{DIGIT}*|0
INTEGER ("+"|"-")?{PINTEGER}
DECIMAL {INTEGER}(.)[0-9]+
LETTER [a-zA-Z]
VARIATE ({LETTER}|_)({LETTER}|_|{DIGIT})*
INDEX [0-9]*[.][0-9]+([e][+-]?[0-9]+|[0])
OPT ("+="|"-="|"*="|"/="|"+"|"-"|"*"|"/"|"<="|">="|"=="|"="|"!="|"!"|"?"|"<"|">")
BRACKET ("{"|"}"|"("|")"|",")
AERROR [0-9]*(.)[0-9]+e
%%
\n  {++line;}
"/*"([^\*]|(\*)*[^\*/])*(\*)*"*/" {printf("");}
(char|double|enum|float|int|long|short) {textv[i]=strdup(yytext);word[i].type1=1;word[i].linev=line;i++;}
(if|else|switch|case|return|main) {textv[i]=strdup(yytext);word[i].typev=2;word[i].linev=line;i++;}
{OPT} {textv[i]=strdup(yytext);word[i].typev=3;word[i].linev=line;i++;}
{INTEGER} {textv[i]=strdup(yytext);word[i].typev=4;word[i].linev=line;i++;}
{DECIMAL} {textv[i]=strdup(yytext);word[i].typev=5;word[i].linev=line;i++;}
{VARIATE} {textv[i]=strdup(yytext);word[i].typev=6;word[i].linev=line;i++;}
{INDEX} {textv[i]=strdup(yytext);word[i].typev=7;word[i].linev=line;i++;}
{BRACKET} {textv[i]=strdup(yytext);word[i].typev=8;word[i].linev=line;i++;}
{AERROR} {printf("Error type A at Line %d: Illegal floating point number \"%s\".",line,yytext);flag=true;}
.|; {}
%%
int yywrap(){
     return 1;
}
int main(){
       yylex();
       if(!flag){
       for(j=0;j<i;j++){
       	switch(word[i].typev):
       case 1:	printf("line%d:(type, %s)\n",word[j].linev,textv[j]);break;
       case 2:	printf("line%d:(identify, %s)\n",word[j].linev,textv[j]);break;
       case 3:  printf("line%d:(OPT, %s)\n",word[j].linev,textv[j]);  break;
       case 4:	printf("line%d:(integer, %s)\n",word[j].linev,textv[j]);break;
       case 5:	printf("line%d:(decimal, %s)\n",word[j].linev,textv[j]);break;
       case 6:	printf("line%d:(identify, %s)\n",word[j].linev,textv[j]);break;
       case 7:	printf("line%d:(float, %s)\n",word[j].linev,textv[j]);break;
       case 8:  printf("line%d:(bracket, \"%s\")\n",word[j].linev,textv[j]);break;
      	 }
       }
   return 0;
}