%{

#include <bits/stdc++.h>
using namespace std;

void yyerror (char *s);
extern "C" int yylex();
extern int chapters,sections,words;
extern string data;
extern string title;
int paras=0, sentences=0, ds=0, is=0, es=0;
%}

%union{
	char *str;
}


%token <str> TITLE CHAPTER SECTION NEWLINES
%token <str> WORD COMMASEP SEMICOLONSEP WS

%%

Start
    :TITLE Chapters 
    ;

Chapters
    : Chapter
    | Chapters Chapter 
    ;

Chapter
    : CHAPTER ChapterContent 
    ;

ChapterContent
    : Paras
    | Sections
    | Paras Sections
    ;

Sections
    : Section
    | Sections Section
    ;

Section
    : SECTION Paras 
    ;

Paras
    : Para {paras++;}
    | Paras NEWLINES Para{paras++;}
    ;

Para
    : Sentence
    | Para WS Sentence 
    | Para Sentence
    ;

Sentence
    : Halfsent '.'  {ds++;sentences++;}
    | Halfsent '?' {is++;sentences++;}
    | Halfsent '!' {es++;sentences++;}
    ;

Halfsent
    : WORD 
    | Halfsent WordSep WORD 
    ;

WordSep
    : WS 
    | COMMASEP 
    | SEMICOLONSEP 
    ;




%%                    


int main () {

	int ret = yyparse();
    cout << title << '\n';
    cout << "Number of Chapters: " << chapters << '\n';
    cout << "Number of Sections: " << sections << '\n';
    cout << "Number of Paragraphs: " << paras << '\n';
    cout << "Number of Sentences: " << sentences << '\n';
    cout << "Number of Words: " << words << '\n';
    cout << "Number of Declarative Sentences: " << ds << '\n';
    cout << "Number of Exclamatory Sentences: " << es << '\n';
    cout << "Number of Interrogative Sentences: " << is << '\n';
    cout << "Table of Contents:\n";
    cout << data;
    return ret;
}

void yyerror (char *s) {cerr<<"Syntax Error";return;} 
