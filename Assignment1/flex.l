%{
#include<iostream>
#include<map>
#include<vector>
#include<utility>
#include<algorithm>
using namespace std;

struct data{
    string token;
    long long int count;
    long long int order;
};
map<string, data> lexeme;
int cur_num=0, line_num=1, err=0;
%}

whitespace [ \t\n\r\f]
letter [a-zA-Z_$]
digit [0-9]
keyword "abstract"|"assert"|"boolean"|"break"|"byte"|"case"|"catch"|"char"|"class"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extends"|"final"|"finally"|"float"|"for"|"if"|"goto"|"implements"|"import"|"instanceof"|"int"|"interface"|"long"|"native"|"new"|"package"|"private"|"protected"|"public"|"return"|"short"|"static"|"strictfp"|"super"|"switch"|"synchronized"|"this"|"throw"|"throws"|"transient"|"try"|"void"|"volatile"|"while"
separator "("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::"
operator "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="
operator_rescue "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="
id {letter}+({letter}|{digit})*
single_line_comment "//"([^\n\r]*)
multi_line_comment "/*"([^*]|\*+[^*/])*\*+"/"
boolean_literal "true"|"false"
hex_digit [0-9a-fA-F]
char_literal \'([^'\\\n\r]|\\([btnfr"'\\]|[0-7]|[0-7][0-7]|[0-3][0-7][0-7]|(u)+{hex_digit}{4}))\'
string_literal \"([^"\\\n\r]|\\([btnfr"'\\]|[0-7]|[0-7][0-7]|[0-3][0-7][0-7]|(u)+{hex_digit}{4}))*\" 
null_literal "null"
decimal_numeral (0|[1-9][0-9]*|[1-9]([0-9]|_)*[0-9])
hex_numeral (0(x|X)({hex_digit}+|{hex_digit}({hex_digit}|_)*{hex_digit}))
octal_numeral (0([0-7]+|([0-7]|_)*[0-7]))
binary_numeral (0(b|B)([01]+|[01]([01]|_)*[01]))
integer_literal ({decimal_numeral}|{hex_numeral}|{octal_numeral}|{binary_numeral})[lL]?
digits ([0-9]|[0-9]([0-9]|_)*[0-9])
hex_digits ({hex_digit}|{hex_digit}({hex_digit}|_)*{hex_digit})
exp ([eE][+-]?{digits})
dec_float_literal ((({digits}\.{digits}?|\.{digits}){exp}?[fFdD]?)|{digits}({exp}[fFdD]?|{exp}?[fFdD]))
hex_float_literal (({hex_numeral}[.]?|0[xX]{hex_digits}?\.{hex_digits})[pP][+-]?{digits}[fFdD]?) 
float_literal {dec_float_literal}|{hex_float_literal}
literal {boolean_literal}|{char_literal}|{string_literal}|{null_literal}|{integer_literal}|{float_literal}

%%
{whitespace} {  if(yyleng>1 && yytext[0]=='\r' && yytext[1]=='\n')  line_num++;
                else{
                    if(yytext[0]=='\n'|| yytext[0]=='\r') line_num++;}}
{single_line_comment} {}
{multi_line_comment} {int curr=2;
    while(!(yytext[curr]=='*' && yytext[curr+1]=='/')){
        if(yytext[curr]=='\r' && yytext[curr+1]=='\n') line_num++,curr+=1;
        else{
            if(yytext[curr]=='\r' || yytext[curr]=='\n')    line_num++;
        }
        curr++;
    }}
{keyword} {if(lexeme.find(yytext)==lexeme.end()){
                struct data temp = {"Keyword",1,cur_num};
                lexeme[yytext]= temp;
                cur_num++;
           }
           else lexeme[yytext].count++;
          }
{separator} {if(lexeme.find(yytext)==lexeme.end()){
                struct data temp = {"Separator",1,cur_num};
                lexeme[yytext]= temp;
                cur_num++;
           }
           else lexeme[yytext].count++;
          }
{operator} {if(lexeme.find(yytext)==lexeme.end()){
                struct data temp = {"Operator",1,cur_num};
                lexeme[yytext]= temp;
                cur_num++;
           }
           else lexeme[yytext].count++;
          }
{literal} {if(lexeme.find(yytext)==lexeme.end()){
                struct data temp = {"Literal",1,cur_num};
                lexeme[yytext]= temp;
                cur_num++;
           }
           else lexeme[yytext].count++;
          }
{id} {if(lexeme.find(yytext)==lexeme.end()){
                struct data temp = {"Identifier",1,cur_num};
                lexeme[yytext]= temp;
                cur_num++;
           }
           else lexeme[yytext].count++;
          }
. {cerr << "Error: Illegal pattern " << yytext << " at line number:" << line_num << "\n";
    err=1;}

%%
int yywrap(){}

struct final_data{
    long long int count;
    string lexeme, token;
};

bool compare(pair<long long int, final_data> &a, pair<long long int, final_data> &b){
    return a.first < b.first;
}

int main(){
    
    yylex();
    vector<pair<long long int, final_data>> ans;

    for(auto it:lexeme){
        struct final_data temp = {it.second.count, it.first, it.second.token};
        ans.push_back({it.second.order, temp});
    }
    sort(ans.begin(),ans.end(),compare);
    if(err==0){
        cout << "Lexeme,Token,Count\n";
        for(auto it1:ans){
            cout << it1.second.lexeme << "," << it1.second.token << "," << it1.second.count << '\n';
        }
        return 0;
    }
    else{
        return -1;
    }
    /*cout << line_num;    */
}
