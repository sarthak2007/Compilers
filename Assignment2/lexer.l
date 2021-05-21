%{


#include <bits/stdc++.h>
using namespace std;
#include "parser.tab.h"
void yyerror (char *s);
extern "C" int yylex();
string improve(string a){
 /*return a;*/
    int pos=0,l=a.length();
    for(int i=0;i<l;i++){
        if(a[i]==':'){
            pos=i;break;
        }
    }
    int temp=pos-1;
    while(temp>=0 && a[temp]==' ')  temp--;
    a = a.substr(0,temp+1)+": "+a.substr(pos+1);
    string ans="";
    l = a.length();
    int i=0;
    for(i=0;i<l-1;i++){
        while(a[i]==' ' && a[i+1]==' ')    i++;
        ans+=a.substr(i,1);
    }
    if(i==l-1){
        ans+=a.substr(l-1,1);
    }
    return ans;
}
int chapters=0,sections=0,words=0;
string data="",title="";
%}


%%

"Title".* { title = improve(string(yytext));
            return (TITLE); }
\n+"Chapter".*\n+ {yylval.str=strdup(yytext);chapters++;
                    string temp = string(yytext);
                    int l=0,r=temp.length()-1;
                    int cnt=0;
                    while(temp[l]=='\n') l++,cnt++;
                    while(temp[r]=='\n') cnt++,r--;
                    data+=improve(temp.substr(l,temp.length()-cnt))+'\n'; return (CHAPTER);}
\n*"Section".*\n+ {yylval.str=strdup(yytext);sections++; 
                    string temp = string(yytext);
                    int l=0,r=temp.length()-1;
                    int cnt=0;
                    while(temp[l]=='\n') l++,cnt++;
                    while(temp[r]=='\n') cnt++,r--;
                    data+="    "+improve(temp.substr(l,temp.length()-cnt))+'\n'; return (SECTION);}
[A-Za-z]+ {yylval.str=strdup(yytext); words++;return (WORD);}
\n\n+ {yylval.str=strdup(yytext); return (NEWLINES);}
" "+ {yylval.str=strdup(yytext); return (WS);}
", " {yylval.str=strdup(yytext); return (COMMASEP);}
"; " {yylval.str=strdup(yytext); return (SEMICOLONSEP);}
"." {yylval.str=strdup(yytext); return '.';}
"?" {yylval.str=strdup(yytext); return '?';}
"!" {yylval.str=strdup(yytext); return '!';}
([0-9]+)|([0-9]+\.[0-9]+) {return (WORD); }
.|\n {cerr << "Syntax Error: ";cout << yytext;exit(-1);}

%%


int yywrap(void){ return 1;} 



