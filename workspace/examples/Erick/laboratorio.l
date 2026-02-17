%{
#include <stdio.h>
%}

/* Expresiones Regulares para facilitar la lectura */
DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          ({LETRA}|_)(({LETRA}|{DIGITO}|_)*)
HEX         0[xX][0-9a-fA-F]+
ESPACIO     [ \t\r]+

%%

    /* 4. Comentarios se descartan*/
"//".* { /* Ignorar comentario de una línea */ }
"/*"([^*]|\*+[^/*])*"*"+"/" { /* Ignorar comentario multilínea */ }

    /* 1. Identificadores */
{ID}                        { printf("TOKEN: IDENTIFICADOR | Valor: %s\n", yytext); }

    /* 2. Literales Numéricos */
{HEX}                       { printf("TOKEN: HEXADECIMAL | Valor: %s\n", yytext); }
{DIGITO}+                   { printf("TOKEN: ENTERO | Valor: %s\n", yytext); }
{DIGITO}+"."{DIGITO}+       { printf("TOKEN: FLOTANTE | Valor: %s\n", yytext); }
{DIGITO}+("."{DIGITO}+)?[eE][+-]?{DIGITO}+ { printf("TOKEN: NOTACION_CIENTIFICA | Valor: %s\n", yytext); }

    /* 3. Operadores*/
"+"|"-"|"*"|"/"             { printf("TOKEN: OP_ARITMETICO | Valor: %s\n", yytext); }
"=="|"!="|"<"|">"|"<="|">=" { printf("TOKEN: OP_RELACIONAL | Valor: %s\n", yytext); }
"&&"|"||"|"!"               { printf("TOKEN: OP_LOGICO | Valor: %s\n", yytext); }
"="                         { printf("TOKEN: ASIGNACION | Valor: %s\n", yytext); }
";"|","|"("|")"|"{"|"}"     { printf("TOKEN: PUNTUACION | Valor: %s\n", yytext); }

    /* 5. Cadenas Literales con escapes */
\"([^"\\\n]|\\.)*\"         { printf("TOKEN: STRING | Valor: %s\n", yytext); }

    /* Manejo de espacios y saltos de línea */
{ESPACIO}                   { /* Ignorar */ }
\n                          { /* Ignorar */ }

.                           { printf("ERROR LÉXICO: Caracter no reconocido '%s'\n", yytext); }

%%

int yywrap() { return 1; }

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    }
    yylex();
    return 0;
}
